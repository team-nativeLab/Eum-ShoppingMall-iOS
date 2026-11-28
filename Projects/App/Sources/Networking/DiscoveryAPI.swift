import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct DiscoveryAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/products/recommended — 검색 결과가 없을 때의 추천 상품.
    func recommendedProducts(limit: Int? = nil, accessToken: String? = nil) async throws -> [APIProductSummary] {
        var queryItems: [URLQueryItem] = []
        if let limit { queryItems.append(URLQueryItem(name: "limit", value: String(limit))) }
        let request = APIRequest<[APIProductSummary]>(
            path: "api/v1/products/recommended",
            queryItems: queryItems,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// GET /api/v1/products/{productId}/related — 상품 상세의 "함께 구매하면 좋은 제품".
    func relatedProducts(
        productID: Int64,
        limit: Int? = nil,
        accessToken: String? = nil
    ) async throws -> [APIProductSummary] {
        var queryItems: [URLQueryItem] = []
        if let limit { queryItems.append(URLQueryItem(name: "limit", value: String(limit))) }
        let request = APIRequest<[APIProductSummary]>(
            path: "api/v1/products/\(productID)/related",
            queryItems: queryItems,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// GET /api/v1/search/recommended-keywords — 운영자가 정한 순서대로.
    func recommendedKeywords(accessToken: String? = nil) async throws -> [String] {
        let request = APIRequest<[String]>(path: "api/v1/search/recommended-keywords", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// GET /api/v1/popups — 노출 중인 팝업.
    func popups(accessToken: String? = nil) async throws -> [APIPopupResponse] {
        let request = APIRequest<[APIPopupResponse]>(path: "api/v1/popups", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// GET /api/v1/company — 푸터의 사업자·고객센터 정보.
    func company(accessToken: String? = nil) async throws -> APICompanyInfo {
        let request = APIRequest<APICompanyInfo>(path: "api/v1/company", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// GET /api/v1/checkout/options — 배송비·무료배송 기준(관리자 배송비 정책), 배송 요청 문구, 배송 방법, 결제 수단
    func checkoutOptions(accessToken: String? = nil) async throws -> APICheckoutOptionsResponse {
        let request = APIRequest<APICheckoutOptionsResponse>(path: "api/v1/checkout/options", accessToken: accessToken)
        return try await client.sendData(request)
    }
}
