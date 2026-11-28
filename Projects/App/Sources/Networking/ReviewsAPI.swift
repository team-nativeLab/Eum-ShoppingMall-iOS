import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct ReviewsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/products/{productId}/reviews — 리뷰 목록.
    func reviews(
        productID: Int64,
        sort: String? = nil,
        page: Int? = nil,
        size: Int? = nil,
        accessToken: String? = nil
    ) async throws -> APIPage<APIProductReviewResponse> {
        var queryItems: [URLQueryItem] = []
        if let sort { queryItems.append(URLQueryItem(name: "sort", value: sort)) }
        if let page { queryItems.append(URLQueryItem(name: "page", value: String(page))) }
        if let size { queryItems.append(URLQueryItem(name: "size", value: String(size))) }
        let request = APIRequest<APIPage<APIProductReviewResponse>>(
            path: "api/v1/products/\(productID)/reviews",
            queryItems: queryItems,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// POST /api/v1/products/{productId}/reviews — 리뷰 작성.
    func createReview(
        productID: Int64,
        body: APIProductReviewCreateRequest,
        accessToken: String? = nil
    ) async throws -> APIProductReviewResponse {
        let request = try APIRequest<APIProductReviewResponse>.json(
            path: "api/v1/products/\(productID)/reviews",
            method: .post,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// GET /api/v1/products/{productId}/reviews/summary — 평균 별점과 별점별 리뷰 수
    func reviewSummary(productID: Int64, accessToken: String? = nil) async throws -> APIProductReviewSummaryResponse {
        let request = APIRequest<APIProductReviewSummaryResponse>(
            path: "api/v1/products/\(productID)/reviews/summary",
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// GET /api/v1/me/reviewable-items — 리뷰를 쓸 수 있는 내 주문 상품(배송 완료, 아직 리뷰 없음)
    func reviewableItems(accessToken: String? = nil) async throws -> [APIReviewableItemResponse] {
        let request = APIRequest<[APIReviewableItemResponse]>(
            path: "api/v1/me/reviewable-items",
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }
}
