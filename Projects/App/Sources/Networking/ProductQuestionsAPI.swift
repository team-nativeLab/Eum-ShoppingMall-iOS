import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct ProductQuestionsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/products/{productId}/questions — 문의 목록(누구나).
    func questions(
        productID: Int64,
        page: Int? = nil,
        size: Int? = nil,
        sort: [String]? = nil,
        accessToken: String? = nil
    ) async throws -> APIPage<APIProductQuestionResponse> {
        var queryItems: [URLQueryItem] = []
        if let page { queryItems.append(URLQueryItem(name: "page", value: String(page))) }
        if let size { queryItems.append(URLQueryItem(name: "size", value: String(size))) }
        for value in sort ?? [] { queryItems.append(URLQueryItem(name: "sort", value: value)) }
        let request = APIRequest<APIPage<APIProductQuestionResponse>>(
            path: "api/v1/products/\(productID)/questions",
            queryItems: queryItems,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// POST /api/v1/products/{productId}/questions — 문의 작성(회원).
    func createQuestion(
        productID: Int64,
        body: APIProductQuestionCreateRequest,
        accessToken: String? = nil
    ) async throws -> APIProductQuestionResponse {
        let request = try APIRequest<APIProductQuestionResponse>.json(
            path: "api/v1/products/\(productID)/questions",
            method: .post,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }
}
