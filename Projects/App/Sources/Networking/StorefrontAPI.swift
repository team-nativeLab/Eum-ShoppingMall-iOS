import Foundation

struct StorefrontAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func home() async throws -> APIHomeResponse {
        try await client.sendData(APIRequest<APIHomeResponse>(path: "api/v1/home"))
    }

    func content(code: String) async throws -> APIContentResponse {
        try await client.sendData(APIRequest<APIContentResponse>(path: "api/v1/contents/\(code)"))
    }

    func appConfig() async throws -> APIAppConfigResponse {
        try await client.sendData(APIRequest<APIAppConfigResponse>(path: "api/v1/app/config"))
    }

    func shippingPolicy() async throws -> APIShippingPolicyResponse {
        try await client.sendData(APIRequest<APIShippingPolicyResponse>(path: "api/v1/shipping-policy"))
    }
}

struct APIHomeResponse: Decodable {
    let banners: [APIHomeBanner]?
    let newProducts: [APIProductSummary]?
}

struct APIHomeBanner: Decodable {
    let id: Int64?
    let imageUrl: String?
    let linkUrl: String?
}

struct APIContentResponse: Decodable {
    let code: String?
    let title: String?
    let body: String?
    let updatedAt: String?
}

struct APIAppConfigResponse: Decodable {
    let minVersion: String?
    let latestVersion: String?
    let maintenance: Bool
    let maintenanceMessage: String?
}

struct APIShippingPolicyResponse: Decodable {
    let shippingFee: Int64
    let freeShippingThreshold: Int64?
    let updatedAt: String?
}
