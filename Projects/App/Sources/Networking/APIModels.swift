import Foundation

struct APIPage<Content: Decodable>: Decodable {
    let content: [Content]
    let page: Int
    let size: Int
    let totalElements: Int64
    let totalPages: Int
}

extension APIEnvelope {
    func requireData() throws -> Payload {
        guard let data else {
            throw APIClientError.invalidPayload
        }
        return data
    }
}
