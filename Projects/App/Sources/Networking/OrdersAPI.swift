import Foundation

struct OrdersAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func createOrder(
        items: [APIOrderItemRequest],
        delivery: APIOrderDeliveryRequest,
        idempotencyKey: String? = nil,
        accessToken: String
    ) async throws -> APIOrderCreateResponse {
        let body = APIOrderCreateRequest(items: items, delivery: delivery)
        let request = try APIRequest<APIOrderCreateResponse>.json(
            path: "api/v1/orders",
            method: .post,
            body: body,
            accessToken: accessToken,
            idempotencyKey: idempotencyKey
        )
        return try await client.sendData(request)
    }

    func orders(page: Int? = nil, size: Int? = nil, accessToken: String) async throws -> APIPage<APIOrderSummary> {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let size {
            queryItems.append(URLQueryItem(name: "size", value: String(size)))
        }
        return try await client.sendData(
            APIRequest<APIPage<APIOrderSummary>>(
                path: "api/v1/orders",
                queryItems: queryItems,
                accessToken: accessToken
            )
        )
    }

    func order(orderNo: String, accessToken: String) async throws -> APIOrderDetail {
        try await client.sendData(
            APIRequest<APIOrderDetail>(path: "api/v1/orders/\(orderNo)", accessToken: accessToken)
        )
    }

    func cancelOrder(orderNo: String, accessToken: String) async throws -> APIOrderDetail {
        try await client.sendData(
            APIRequest<APIOrderDetail>(
                path: "api/v1/orders/\(orderNo)/cancel",
                method: .post,
                accessToken: accessToken
            )
        )
    }

    func confirmPayment(
        paymentKey: String,
        orderID: String,
        amount: Int64,
        accessToken: String
    ) async throws -> APIOrderDetail {
        let body = APIPaymentConfirmRequest(paymentKey: paymentKey, orderId: orderID, amount: amount)
        let request = try APIRequest<APIOrderDetail>.json(
            path: "api/v1/payments/confirm",
            method: .post,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }
}

struct APIOrderCreateRequest: Encodable {
    let items: [APIOrderItemRequest]
    let delivery: APIOrderDeliveryRequest
}

struct APIOrderItemRequest: Encodable {
    let skuId: Int64
    let quantity: Int
}

struct APIOrderDeliveryRequest: Encodable {
    let recipient: String
    let recipientPhone: String
    let zipCode: String
    let address: String
    let addressDetail: String?
    let deliveryRequest: String?
}

struct APIPaymentConfirmRequest: Encodable {
    let paymentKey: String
    let orderId: String
    let amount: Int64
}

struct APIOrderCreateResponse: Decodable {
    let orderNo: String?
    let orderName: String?
    let amount: Int64
    let expiresAt: String?
}

struct APIOrderSummary: Decodable {
    let orderNo: String?
    let status: String?
    let orderName: String?
    let totalAmount: Int64
    let createdAt: String?
}

struct APIOrderDetail: Decodable {
    let orderNo: String?
    let status: String?
    let orderName: String?
    let itemAmount: Int64
    let discountAmount: Int64
    let shippingFee: Int64
    let totalAmount: Int64
    let shippingAddress: APIOrderAddress?
    let courier: String?
    let trackingNumber: String?
    let items: [APIOrderItem]?
    let payment: APIOrderPayment?
    let createdAt: String?
    let paidAt: String?
    let expiresAt: String?
}

struct APIOrderAddress: Decodable {
    let recipient: String?
    let recipientPhone: String?
    let zipCode: String?
    let address: String?
    let addressDetail: String?
    let deliveryRequest: String?
}

struct APIOrderItem: Decodable {
    let id: Int64?
    let skuId: Int64?
    let productName: String?
    let optionName: String?
    let orderPrice: Int64
    let quantity: Int
    let status: String?
}

struct APIOrderPayment: Decodable {
    let method: String?
    let status: String?
    let approvedAmount: Int64
    let balanceAmount: Int64
    let approvedAt: String?
    let virtualAccount: APIOrderVirtualAccount?
}

struct APIOrderVirtualAccount: Decodable {
    let bankCode: String?
    let accountNumber: String?
    let customerName: String?
    let dueDate: String?
    let expired: Bool
}
