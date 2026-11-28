import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct LegalDocumentsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/legal-documents/{type} — 지금 시행 중인 공개 버전.
    func legalDocument(
        type: String,
        version: String? = nil,
        accessToken: String? = nil
    ) async throws -> APILegalDocumentResponse {
        var queryItems: [URLQueryItem] = []
        if let version { queryItems.append(URLQueryItem(name: "version", value: version)) }
        let request = APIRequest<APILegalDocumentResponse>(
            path: "api/v1/legal-documents/\(type)",
            queryItems: queryItems,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// GET /api/v1/legal-documents/{type}/versions — 공개 버전 목록(시행 예정 포함, 본문 제외).
    func legalDocumentVersions(type: String, accessToken: String? = nil) async throws -> [APIVersion] {
        let request = APIRequest<[APIVersion]>(
            path: "api/v1/legal-documents/\(type)/versions",
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }
}
