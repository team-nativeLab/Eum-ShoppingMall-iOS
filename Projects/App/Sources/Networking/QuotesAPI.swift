import Foundation

struct QuotesAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func create(
        _ quote: APIQuoteCreateRequest,
        accessToken: String? = nil
    ) async throws -> APIQuote {
        let request = try APIRequest<APIQuote>.json(
            path: "api/v1/quotes",
            method: .post,
            body: quote,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    func myQuotes(
        page: Int? = nil,
        size: Int? = nil,
        accessToken: String
    ) async throws -> APIPage<APIQuote> {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let size {
            queryItems.append(URLQueryItem(name: "size", value: String(size)))
        }
        return try await client.sendData(
            APIRequest<APIPage<APIQuote>>(
                path: "api/v1/quotes",
                queryItems: queryItems,
                accessToken: accessToken
            )
        )
    }
}

struct APIQuoteCreateRequest: Encodable {
    let productId: Int64?
    let companyName: String
    let managerName: String
    let phone: String
    let email: String?
    let content: String
    let privacyAgreed: Bool?
}

struct APIQuote: Decodable {
    let id: Int64?
    let productId: Int64?
    let companyName: String?
    let managerName: String?
    let phone: String?
    let email: String?
    let content: String?
    let status: String?
    let createdAt: String?
}
