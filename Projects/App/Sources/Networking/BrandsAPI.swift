import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct BrandsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/brands — 보이는 브랜드 목록.
    func brands(accessToken: String? = nil) async throws -> [APISummary] {
        let request = APIRequest<[APISummary]>(path: "api/v1/brands", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// GET /api/v1/brands/featured — 대표 브랜드.
    func featuredBrands(accessToken: String? = nil) async throws -> APIBrandDetail? {
        let request = APIRequest<APIBrandDetail>(path: "api/v1/brands/featured", accessToken: accessToken)
        return try await client.send(request).data
    }

    /// GET /api/v1/brands/{brandId} — 브랜드 상세.
    func brand(brandID: Int64, accessToken: String? = nil) async throws -> APIBrandDetail {
        let request = APIRequest<APIBrandDetail>(path: "api/v1/brands/\(brandID)", accessToken: accessToken)
        return try await client.sendData(request)
    }
}
