import Foundation

struct APIConfiguration {
    static let baseURLInfoKey = "EUM_API_BASE_URL"

    let baseURL: URL

    init(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) throws {
        guard
            let rawValue = infoDictionary?[Self.baseURLInfoKey] as? String,
            !rawValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !rawValue.contains("$("),
            let url = URL(string: rawValue)
        else {
            throw APIClientError.missingBaseURL
        }

        try self.init(baseURL: url)
    }

    init(baseURL: URL) throws {
        guard
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false),
            components.scheme?.lowercased() == "https",
            let host = components.host,
            !host.isEmpty,
            components.user == nil,
            components.password == nil,
            components.query == nil,
            components.fragment == nil
        else {
            throw APIClientError.invalidBaseURL
        }

        if !components.path.hasSuffix("/") {
            components.path += "/"
        }

        guard let normalizedURL = components.url else {
            throw APIClientError.invalidBaseURL
        }

        self.baseURL = normalizedURL
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct APIFieldError: Decodable {
    let field: String
    let reason: String
}

struct APIErrorPayload: Decodable {
    let code: String?
    let message: String?
    let errors: [APIFieldError]?
}

struct APIEnvelope<Payload: Decodable>: Decodable {
    let success: Bool
    let code: String
    let message: String
    let data: Payload?
    let errors: [APIFieldError]?
    let timestamp: String?
}

struct APIRequest<Payload: Decodable> {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
    let body: Data?
    let accessToken: String?

    init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil,
        accessToken: String? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.accessToken = accessToken
    }

    static func json<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        queryItems: [URLQueryItem] = [],
        body: Body,
        accessToken: String? = nil
    ) throws -> Self {
        Self(
            path: path,
            method: method,
            queryItems: queryItems,
            body: try JSONEncoder().encode(body),
            accessToken: accessToken
        )
    }
}

struct APIClient {
    private let configuration: APIConfiguration
    private let session: URLSession

    init(configuration: APIConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func send<Payload: Decodable>(
        _ apiRequest: APIRequest<Payload>
    ) async throws -> APIEnvelope<Payload> {
        let url = try makeURL(
            path: apiRequest.path,
            queryItems: apiRequest.queryItems
        )
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        request.httpBody = apiRequest.body
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if apiRequest.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let accessToken = apiRequest.accessToken,
           !accessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        let decoder = JSONDecoder()
        guard (200..<300).contains(response.statusCode) else {
            let errorPayload = try? decoder.decode(APIErrorPayload.self, from: data)
            throw APIClientError.httpFailure(
                statusCode: response.statusCode,
                payload: errorPayload
            )
        }

        let envelope: APIEnvelope<Payload>
        do {
            envelope = try decoder.decode(APIEnvelope<Payload>.self, from: data)
        } catch {
            throw APIClientError.invalidPayload
        }

        guard envelope.success else {
            throw APIClientError.serverRejected(
                code: envelope.code,
                message: envelope.message,
                errors: envelope.errors
            )
        }

        return envelope
    }

    private func makeURL(
        path: String,
        queryItems: [URLQueryItem]
    ) throws -> URL {
        let normalizedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let pathSegments = normalizedPath.split(separator: "/")
        guard !pathSegments.isEmpty, !pathSegments.contains(where: { $0 == ".." || $0 == "." }) else {
            throw APIClientError.invalidPath
        }

        let endpoint = pathSegments
            .map(String.init)
            .reduce(configuration.baseURL) { url, segment in
                url.appendingPathComponent(segment)
            }

        guard var components = URLComponents(
            url: endpoint,
            resolvingAgainstBaseURL: false
        ) else {
            throw APIClientError.invalidPath
        }

        components.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components.url else {
            throw APIClientError.invalidPath
        }
        return url
    }
}

enum APIClientError: Error, LocalizedError {
    case missingBaseURL
    case invalidBaseURL
    case invalidPath
    case invalidResponse
    case invalidPayload
    case httpFailure(statusCode: Int, payload: APIErrorPayload?)
    case serverRejected(code: String, message: String, errors: [APIFieldError]?)

    var errorDescription: String? {
        switch self {
        case .missingBaseURL:
            return "API base URL is not configured."
        case .invalidBaseURL:
            return "API base URL must be a valid HTTPS URL without credentials, query, or fragment."
        case .invalidPath:
            return "API path is invalid."
        case .invalidResponse:
            return "The server returned an invalid HTTP response."
        case .invalidPayload:
            return "The server response could not be decoded."
        case let .httpFailure(statusCode, payload):
            return payload?.message ?? "The server returned HTTP \(statusCode)."
        case let .serverRejected(_, message, _):
            return message
        }
    }
}
