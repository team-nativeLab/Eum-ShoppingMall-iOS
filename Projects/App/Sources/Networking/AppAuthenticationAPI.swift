import Foundation

/// App-specific authentication (`/api/v1/app/auth/*`).
/// Unlike the web flow, both tokens are returned in the response body (no cookies),
/// and every refresh rotates the refresh token.
struct AppAuthenticationAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func login(email: String, password: String, captchaToken: String? = nil) async throws -> APIAppTokenResponse {
        let body = APIAuthLoginRequest(email: email, password: password, captchaToken: captchaToken)
        let request = try APIRequest<APIAppTokenResponse>.json(
            path: "api/v1/app/auth/login",
            method: .post,
            body: body
        )
        return try await client.sendData(request)
    }

    func refresh(refreshToken: String) async throws -> APIAppTokenResponse {
        let request = try APIRequest<APIAppTokenResponse>.json(
            path: "api/v1/app/auth/refresh",
            method: .post,
            body: APIAppRefreshRequest(refreshToken: refreshToken)
        )
        return try await client.sendData(request)
    }

    func logout(accessToken: String?, refreshToken: String) async throws {
        let request = try APIRequest<APIEmptyPayload>.json(
            path: "api/v1/app/auth/logout",
            method: .post,
            body: APIAppRefreshRequest(refreshToken: refreshToken),
            accessToken: accessToken
        )
        _ = try await client.send(request)
    }

    /// `provider` is `kakao` (Kakao SDK access token) or `google` (Google Sign-In ID token).
    func socialLogin(provider: String, token: String) async throws -> APIAppSocialLoginResponse {
        let request = try APIRequest<APIAppSocialLoginResponse>.json(
            path: "api/v1/app/auth/social/\(provider)/login",
            method: .post,
            body: APIAppSocialLoginRequest(token: token)
        )
        return try await client.sendData(request)
    }

    func socialSignUp(_ body: APISocialSignupRequest) async throws -> APIAppTokenResponse {
        let request = try APIRequest<APIAppTokenResponse>.json(
            path: "api/v1/app/auth/social/signup",
            method: .post,
            body: body
        )
        return try await client.sendData(request)
    }
}

struct APIAppRefreshRequest: Encodable {
    let refreshToken: String
}

struct APIAppSocialLoginRequest: Encodable {
    let token: String
}

struct APISocialSignupRequest: Encodable {
    let signupToken: String
    let name: String
    let phone: String?
    let termsAgreed: Bool
    let privacyAgreed: Bool
    let marketingAgreed: Bool?
}

struct APIAppTokenResponse: Decodable, Equatable {
    let accessToken: String
    let expiresIn: Int64
    let refreshToken: String
    let refreshTokenExpiresIn: Int64?
}

struct APIAppSocialLoginResponse: Decodable {
    let signupRequired: Bool
    let accessToken: String?
    let expiresIn: Int64?
    let refreshToken: String?
    let refreshTokenExpiresIn: Int64?
    let signupToken: String?
    let signupTokenExpiresIn: Int64?
    let provider: String?
    let email: String?
    let name: String?
}

/// Persists app tokens in the Keychain and coordinates login, refresh and logout.
/// A single actor serializes refreshes so a rotated refresh token is never reused.
actor AppAuthSession {
    private let api: AppAuthenticationAPI
    private let accessTokenStore: any TokenStoring
    private let refreshTokenStore: any TokenStoring
    private var refreshTask: Task<APIAppTokenResponse, Error>?

    init(
        api: AppAuthenticationAPI,
        accessTokenStore: any TokenStoring = KeychainFallbackTokenStore(account: AccessTokenStore.accessTokenAccount),
        refreshTokenStore: any TokenStoring = KeychainFallbackTokenStore(account: AccessTokenStore.refreshTokenAccount)
    ) {
        self.api = api
        self.accessTokenStore = accessTokenStore
        self.refreshTokenStore = refreshTokenStore
    }

    var isSignedIn: Bool {
        (try? refreshTokenStore.load()) != nil
    }

    func currentAccessToken() -> String? {
        try? accessTokenStore.load()
    }

    @discardableResult
    func login(email: String, password: String) async throws -> APIAppTokenResponse {
        let tokens = try await api.login(email: email, password: password)
        try store(tokens)
        return tokens
    }

    /// Exchanges the stored refresh token for new tokens. Concurrent callers share one request.
    @discardableResult
    func refresh() async throws -> APIAppTokenResponse {
        if let refreshTask {
            return try await refreshTask.value
        }
        guard let refreshToken = try refreshTokenStore.load() else {
            throw AppAuthSessionError.notSignedIn
        }
        let api = self.api
        let task = Task { try await api.refresh(refreshToken: refreshToken) }
        refreshTask = task
        defer { refreshTask = nil }
        do {
            let tokens = try await task.value
            try store(tokens)
            return tokens
        } catch {
            if case APIClientError.httpFailure(statusCode: 401, _) = error {
                clear()
            }
            throw error
        }
    }

    func logout() async {
        let accessToken = try? accessTokenStore.load()
        if let refreshToken = try? refreshTokenStore.load() {
            try? await api.logout(accessToken: accessToken, refreshToken: refreshToken)
        }
        clear()
    }

    private func store(_ tokens: APIAppTokenResponse) throws {
        try accessTokenStore.save(tokens.accessToken)
        try refreshTokenStore.save(tokens.refreshToken)
    }

    private func clear() {
        try? accessTokenStore.remove()
        try? refreshTokenStore.remove()
    }
}

enum AppAuthSessionError: Error, Equatable {
    case notSignedIn
}
