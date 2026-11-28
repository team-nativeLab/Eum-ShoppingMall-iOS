import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct AccountSettingsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/me/social-accounts — 연결한 카카오·구글 계정.
    func socialAccounts(accessToken: String? = nil) async throws -> [APISocialAccountResponse] {
        let request = APIRequest<[APISocialAccountResponse]>(
            path: "api/v1/me/social-accounts",
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// DELETE /api/v1/me/social-accounts/{provider} — 카카오(kakao)·구글(google) 연결 끊기.
    func disconnectSocialAccount(provider: String, accessToken: String? = nil) async throws -> APIEmptyPayload {
        let request = APIRequest<APIEmptyPayload>(
            path: "api/v1/me/social-accounts/\(provider)",
            method: .delete,
            accessToken: accessToken
        )
        _ = try await client.send(request)
        return APIEmptyPayload()
    }

    /// PUT /api/v1/me/marketing-consent — 마케팅 정보 수신 동의·철회(#229).
    func updateMarketingConsent(
        body: APIMarketingConsentRequest,
        accessToken: String? = nil
    ) async throws -> APIMarketingConsentResponse {
        let request = try APIRequest<APIMarketingConsentResponse>.json(
            path: "api/v1/me/marketing-consent",
            method: .put,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }
}
