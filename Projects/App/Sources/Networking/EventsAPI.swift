import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.
struct EventsAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    /// GET /api/v1/events — 보이는 이벤트.
    func events(accessToken: String? = nil) async throws -> [APIShopEventResponse] {
        let request = APIRequest<[APIShopEventResponse]>(path: "api/v1/events", accessToken: accessToken)
        return try await client.sendData(request)
    }

    /// GET /api/v1/events/{eventId} — 이벤트 상세.
    func event(eventID: Int64, accessToken: String? = nil) async throws -> APIShopEventResponse {
        let request = APIRequest<APIShopEventResponse>(path: "api/v1/events/\(eventID)", accessToken: accessToken)
        return try await client.sendData(request)
    }
}
