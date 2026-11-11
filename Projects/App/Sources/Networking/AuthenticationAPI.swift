import Foundation

struct AuthenticationAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func signUp(_ request: APIAuthSignupRequest) async throws -> APIAuthSignupResponse {
        let apiRequest = try APIRequest<APIAuthSignupResponse>.json(
            path: "api/v1/auth/signup",
            method: .post,
            body: request
        )
        return try await client.sendData(apiRequest)
    }

    func sendEmailVerification(email: String, captchaToken: String? = nil) async throws -> APIEmailVerificationSendResponse {
        let body = APIAuthEmailRequest(email: email, captchaToken: captchaToken)
        let request = try APIRequest<APIEmailVerificationSendResponse>.json(
            path: "api/v1/auth/email-verifications",
            method: .post,
            body: body
        )
        return try await client.sendData(request)
    }

    func confirmEmailVerification(
        email: String,
        code: String,
        captchaToken: String? = nil
    ) async throws -> APIEmailVerificationConfirmResponse {
        let body = APIAuthVerificationRequest(email: email, code: code, captchaToken: captchaToken)
        let request = try APIRequest<APIEmailVerificationConfirmResponse>.json(
            path: "api/v1/auth/email-verifications/confirm",
            method: .post,
            body: body
        )
        return try await client.sendData(request)
    }

    func requestPasswordReset(email: String, captchaToken: String? = nil) async throws {
        let body = APIAuthEmailRequest(email: email, captchaToken: captchaToken)
        let request = try APIRequest<APIEmptyPayload>.json(
            path: "api/v1/auth/password-reset",
            method: .post,
            body: body
        )
        _ = try await client.send(request)
    }

    func confirmPasswordReset(
        email: String,
        code: String,
        newPassword: String,
        captchaToken: String? = nil
    ) async throws {
        let body = APIAuthPasswordResetRequest(
            email: email,
            code: code,
            newPassword: newPassword,
            captchaToken: captchaToken
        )
        let request = try APIRequest<APIEmptyPayload>.json(
            path: "api/v1/auth/password-reset/confirm",
            method: .post,
            body: body
        )
        _ = try await client.send(request)
    }

    func login(email: String, password: String, captchaToken: String? = nil) async throws -> APIAuthLoginResponse {
        let body = APIAuthLoginRequest(email: email, password: password, captchaToken: captchaToken)
        let request = try APIRequest<APIAuthLoginResponse>.json(
            path: "api/v1/auth/login",
            method: .post,
            body: body
        )
        return try await client.sendData(request)
    }

    func refresh() async throws -> APIAuthLoginResponse {
        try await client.sendData(APIRequest<APIAuthLoginResponse>(path: "api/v1/auth/refresh", method: .post))
    }

    func logout(accessToken: String) async throws {
        let request = APIRequest<APIEmptyPayload>(
            path: "api/v1/auth/logout",
            method: .post,
            accessToken: accessToken
        )
        _ = try await client.send(request)
    }
}

struct APIAuthSignupRequest: Encodable {
    let email: String
    let password: String
    let name: String
    let phone: String?
    let emailVerificationToken: String?
    let termsAgreed: Bool
    let privacyAgreed: Bool
    let marketingAgreed: Bool?
}

struct APIAuthLoginRequest: Encodable {
    let email: String
    let password: String
    let captchaToken: String?
}

struct APIAuthEmailRequest: Encodable {
    let email: String
    let captchaToken: String?
}

struct APIAuthVerificationRequest: Encodable {
    let email: String
    let code: String
    let captchaToken: String?
}

struct APIAuthPasswordResetRequest: Encodable {
    let email: String
    let code: String
    let newPassword: String
    let captchaToken: String?
}

struct APIAuthSignupResponse: Decodable {
    let id: Int64?
    let email: String?
    let name: String?
}

struct APIAuthLoginResponse: Decodable {
    let accessToken: String?
    let expiresIn: Int64
}

struct APIEmailVerificationSendResponse: Decodable {
    let expiresAt: String?
}

struct APIEmailVerificationConfirmResponse: Decodable {
    let verificationToken: String?
    let expiresAt: String?
}

struct APIEmptyPayload: Decodable {}
