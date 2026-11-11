import Foundation

struct CartAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func cart(accessToken: String) async throws -> APICartResponse {
        try await client.sendData(
            APIRequest<APICartResponse>(path: "api/v1/cart", accessToken: accessToken)
        )
    }

    func addItem(skuID: Int64, quantity: Int, accessToken: String) async throws -> APICartResponse {
        let body = APICartItemAddRequest(skuId: skuID, quantity: quantity)
        let request = try APIRequest<APICartResponse>.json(
            path: "api/v1/cart/items",
            method: .post,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    func updateItem(
        skuID: Int64,
        quantity: Int? = nil,
        selected: Bool? = nil,
        accessToken: String
    ) async throws -> APICartResponse {
        let body = APICartItemUpdateRequest(quantity: quantity, selected: selected)
        let request = try APIRequest<APICartResponse>.json(
            path: "api/v1/cart/items/\(skuID)",
            method: .patch,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    func removeItem(skuID: Int64, accessToken: String) async throws -> APICartResponse {
        try await client.sendData(
            APIRequest<APICartResponse>(
                path: "api/v1/cart/items/\(skuID)",
                method: .delete,
                accessToken: accessToken
            )
        )
    }
}

struct APICartItemAddRequest: Encodable {
    let skuId: Int64
    let quantity: Int
}

struct APICartItemUpdateRequest: Encodable {
    let quantity: Int?
    let selected: Bool?
}

struct APICartResponse: Decodable {
    let items: [APICartItem]?
    let orderableCount: Int
    let itemAmount: Int64
    let shippingFee: Int64
    let paymentAmount: Int64
    let totalAmount: Int64
}

struct APICartItem: Decodable {
    let skuId: Int64?
    let productId: Int64?
    let productName: String?
    let optionName: String?
    let imageUrl: String?
    let quantity: Int
    let selected: Bool
    let priceVisible: Bool
    let price: Int64?
    let amount: Int64?
    let status: String?
}
