import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct AddressesAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/me/addresses — 내 배송지 목록.
    func addresses(accessToken: String? = nil) async throws -> [APIMemberAddressResponse] {
        let request = APIRequest<[APIMemberAddressResponse]>(path: "api/v1/me/addresses", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// POST /api/v1/me/addresses — 배송지 등록.
    func createAddress(
        body: APIMemberAddressRequest,
        accessToken: String? = nil
    ) async throws -> APIMemberAddressResponse {
        let request = try APIRequest<APIMemberAddressResponse>.json(
            path: "api/v1/me/addresses",
            method: .post,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// PUT /api/v1/me/addresses/{addressId} — 배송지 수정.
    func updateAddress(
        addressID: Int64,
        body: APIMemberAddressRequest,
        accessToken: String? = nil
    ) async throws -> APIMemberAddressResponse {
        let request = try APIRequest<APIMemberAddressResponse>.json(
            path: "api/v1/me/addresses/\(addressID)",
            method: .put,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    /// DELETE /api/v1/me/addresses/{addressId} — 배송지 삭제.
    func deleteAddress(addressID: Int64, accessToken: String? = nil) async throws -> APIEmptyPayload {
        let request = APIRequest<APIEmptyPayload>(
            path: "api/v1/me/addresses/\(addressID)",
            method: .delete,
            accessToken: accessToken
        )
        _ = try await client.send(request)
        return APIEmptyPayload()
    }
}
