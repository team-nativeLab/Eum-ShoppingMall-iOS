import Foundation

struct SupportAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func notices(page: Int? = nil, size: Int? = nil) async throws -> APIPage<APINotice> {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let size {
            queryItems.append(URLQueryItem(name: "size", value: String(size)))
        }
        return try await client.sendData(
            APIRequest<APIPage<APINotice>>(path: "api/v1/notices", queryItems: queryItems)
        )
    }

    func notice(id: Int64) async throws -> APINotice {
        try await client.sendData(APIRequest<APINotice>(path: "api/v1/notices/\(id)"))
    }

    func faqs() async throws -> [APIFAQ] {
        try await client.sendData(APIRequest<[APIFAQ]>(path: "api/v1/faqs"))
    }

    func submitInquiry(
        _ inquiry: APIInquiryCreateRequest,
        accessToken: String? = nil
    ) async throws -> APIInquiry {
        let request = try APIRequest<APIInquiry>.json(
            path: "api/v1/support/inquiries",
            method: .post,
            body: inquiry,
            accessToken: accessToken
        )
        return try await client.sendData(request)
    }

    func myInquiries(
        page: Int? = nil,
        size: Int? = nil,
        accessToken: String
    ) async throws -> APIPage<APIInquiry> {
        var queryItems: [URLQueryItem] = []
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let size {
            queryItems.append(URLQueryItem(name: "size", value: String(size)))
        }
        return try await client.sendData(
            APIRequest<APIPage<APIInquiry>>(
                path: "api/v1/support/inquiries",
                queryItems: queryItems,
                accessToken: accessToken
            )
        )
    }
}

struct APINotice: Decodable {
    let id: Int64?
    let title: String?
    let content: String?
    let pinned: Bool
    let createdAt: String?
}

struct APIFAQ: Decodable {
    let id: Int64?
    let category: String?
    let question: String?
    let answer: String?
    let sortOrder: Int
}

struct APIInquiryCreateRequest: Encodable {
    let inquiryType: String
    let title: String
    let content: String
    let contactPhone: String?
    let contactEmail: String?
    let privacyAgreed: Bool?
}

struct APIInquiry: Decodable {
    let id: Int64?
    let inquiryType: String?
    let title: String?
    let content: String?
    let answer: String?
    let status: String?
    let createdAt: String?
}
