import Foundation

struct MemberAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func me(accessToken: String) async throws -> APIMemberProfile {
        try await client.sendData(
            APIRequest<APIMemberProfile>(path: "api/v1/me", accessToken: accessToken)
        )
    }

    func updateProfile(
        name: String,
        phone: String?,
        accessToken: String
    ) async throws -> APIMemberProfile {
        let body = APIProfileUpdateRequest(name: name, phone: phone)
        let request = try APIRequest<APIMemberProfile>.json(
            path: "api/v1/me",
            method: .patch,
            body: body,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    func changePassword(
        currentPassword: String,
        newPassword: String,
        accessToken: String
    ) async throws {
        let body = APIPasswordChangeRequest(currentPassword: currentPassword, newPassword: newPassword)
        let request = try APIRequest<APIEmptyPayload>.json(
            path: "api/v1/me/password",
            method: .patch,
            body: body,
            accessToken: accessToken
        )
        _ = try await client.send(request)
    }

    func withdraw(password: String, accessToken: String) async throws {
        let request = try APIRequest<APIEmptyPayload>.json(
            path: "api/v1/me",
            method: .delete,
            body: APIAccountWithdrawalRequest(password: password),
            accessToken: accessToken
        )
        _ = try await client.send(request)
    }
}

struct APIMemberProfile: Decodable {
    let id: Int64?
    let email: String?
    let name: String?
    let phone: String?
    let role: String?
}

struct APIProfileUpdateRequest: Encodable {
    let name: String
    let phone: String?
}

struct APIPasswordChangeRequest: Encodable {
    let currentPassword: String
    let newPassword: String
}

struct APIAccountWithdrawalRequest: Encodable {
    let password: String
}
