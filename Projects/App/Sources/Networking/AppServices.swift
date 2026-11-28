import Foundation

/// App-wide server access: one API client and one token session built from `EUM_API_BASE_URL`.
@MainActor
final class AppServices {
    static let shared = AppServices()

    let api: ShoppingMallAPI?
    let authSession: AppAuthSession?

    private init() {
        let api = try? ShoppingMallAPI()
        self.api = api
        authSession = api.map { AppAuthSession(api: $0.appAuthentication) }
    }

    func login(email: String, password: String) async throws {
        #if DEBUG
        if let stubbed = Self.stubbedLoginResult() {
            try stubbed.get()
            return
        }
        #endif
        guard let authSession else {
            throw APIClientError.missingBaseURL
        }
        try await authSession.login(email: email, password: password)
    }

    #if DEBUG
    /// UI tests pass `-ui-test-auth-failure <code>` or `-ui-test-auth-success` to stay off the live server.
    private static func stubbedLoginResult(arguments: [String] = ProcessInfo.processInfo.arguments) -> Result<Void, Error>? {
        if arguments.contains("-ui-test-auth-success") {
            return .success(())
        }
        guard let index = arguments.firstIndex(of: "-ui-test-auth-failure") else { return nil }
        let code = arguments.indices.contains(index + 1) ? arguments[index + 1] : "LOGIN_FAILED"
        let status = code == "LOGIN_LOCKED" ? 429 : (code == "CAPTCHA_REQUIRED" ? 400 : 401)
        return .failure(APIClientError.httpFailure(statusCode: status, payload: APIErrorPayload(code: code, message: nil, errors: nil)))
    }
    #endif
}
