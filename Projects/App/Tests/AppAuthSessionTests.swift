import Foundation
import XCTest
@testable import EumShoppingMall

/// Serves canned responses keyed by request path and records the requests it saw.
final class StubURLProtocol: URLProtocol {
    struct Stub {
        let status: Int
        let body: String
    }

    nonisolated(unsafe) static var stubs: [String: [Stub]] = [:]
    nonisolated(unsafe) static var requests: [URLRequest] = []

    static func reset() {
        stubs = [:]
        requests = []
    }

    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        var recorded = request
        if recorded.httpBody == nil, let stream = request.httpBodyStream {
            stream.open()
            var data = Data()
            var buffer = [UInt8](repeating: 0, count: 1024)
            while stream.hasBytesAvailable {
                let count = stream.read(&buffer, maxLength: buffer.count)
                if count <= 0 { break }
                data.append(buffer, count: count)
            }
            stream.close()
            recorded.httpBody = data
        }
        Self.requests.append(recorded)

        let path = request.url?.path ?? ""
        guard var queue = Self.stubs[path], !queue.isEmpty else {
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
            return
        }
        let stub = queue.removeFirst()
        Self.stubs[path] = queue
        guard
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: stub.status, httpVersion: nil, headerFields: nil)
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(stub.body.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

final class AppAuthSessionTests: XCTestCase {
    private var accessStore = InMemoryTokenStore()
    private var refreshStore = InMemoryTokenStore()
    private var session: AppAuthSession!

    override func setUpWithError() throws {
        StubURLProtocol.reset()
        accessStore = InMemoryTokenStore()
        refreshStore = InMemoryTokenStore()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        let client = APIClient(
            configuration: try APIConfiguration(baseURL: XCTUnwrap(URL(string: "https://api.test.example"))),
            session: URLSession(configuration: configuration)
        )
        session = AppAuthSession(
            api: AppAuthenticationAPI(client: client),
            accessTokenStore: accessStore,
            refreshTokenStore: refreshStore
        )
    }

    override func tearDown() {
        StubURLProtocol.reset()
    }

    private static func tokenBody(access: String, refresh: String) -> String {
        """
        {"success":true,"code":"SUCCESS","message":"OK","data":{"accessToken":"\(access)","expiresIn":900,\
        "refreshToken":"\(refresh)","refreshTokenExpiresIn":1209600},"timestamp":"2026-11-28T17:00:00+09:00"}
        """
    }

    func testLoginPostsCredentialsToAppEndpointAndStoresBothTokens() async throws {
        StubURLProtocol.stubs["/api/v1/app/auth/login"] = [.init(status: 200, body: Self.tokenBody(access: "a1", refresh: "r1"))]

        try await session.login(email: "user@example.com", password: "secret")

        let request = try XCTUnwrap(StubURLProtocol.requests.first)
        XCTAssertEqual(request.httpMethod, "POST")
        let body = try XCTUnwrap(request.httpBody.flatMap { try JSONSerialization.jsonObject(with: $0) as? [String: Any] })
        XCTAssertEqual(body["email"] as? String, "user@example.com")
        XCTAssertEqual(try accessStore.load(), "a1")
        XCTAssertEqual(try refreshStore.load(), "r1")
        let signedIn = await session.isSignedIn
        XCTAssertTrue(signedIn)
    }

    func testLoginFailureSurfacesServerCodeAndStoresNothing() async throws {
        StubURLProtocol.stubs["/api/v1/app/auth/login"] = [.init(
            status: 401,
            body: #"{"success":false,"code":"LOGIN_FAILED","message":"이메일 또는 비밀번호가 올바르지 않습니다."}"#
        )]

        do {
            try await session.login(email: "user@example.com", password: "wrong")
            XCTFail("Expected login to fail")
        } catch APIClientError.httpFailure(let status, let payload) {
            XCTAssertEqual(status, 401)
            XCTAssertEqual(payload?.code, "LOGIN_FAILED")
        }
        XCTAssertNil(try accessStore.load())
        XCTAssertNil(try refreshStore.load())
    }

    func testRefreshSendsStoredRefreshTokenAndRotatesIt() async throws {
        try refreshStore.save("r1")
        StubURLProtocol.stubs["/api/v1/app/auth/refresh"] = [.init(status: 200, body: Self.tokenBody(access: "a2", refresh: "r2"))]

        try await session.refresh()

        let body = try XCTUnwrap(StubURLProtocol.requests.first?.httpBody.flatMap {
            try JSONSerialization.jsonObject(with: $0) as? [String: String]
        })
        XCTAssertEqual(body["refreshToken"], "r1")
        XCTAssertEqual(try accessStore.load(), "a2")
        XCTAssertEqual(try refreshStore.load(), "r2")
    }

    func testRejectedRefreshClearsTokens() async throws {
        try accessStore.save("a1")
        try refreshStore.save("used")
        StubURLProtocol.stubs["/api/v1/app/auth/refresh"] = [.init(
            status: 401,
            body: #"{"success":false,"code":"UNAUTHORIZED","message":"인증이 필요합니다."}"#
        )]

        do {
            try await session.refresh()
            XCTFail("Expected refresh to fail")
        } catch {}
        XCTAssertNil(try accessStore.load())
        XCTAssertNil(try refreshStore.load())
    }

    func testRefreshWithoutStoredTokenThrowsNotSignedIn() async {
        do {
            try await session.refresh()
            XCTFail("Expected notSignedIn")
        } catch {
            XCTAssertEqual(error as? AppAuthSessionError, .notSignedIn)
        }
        XCTAssertTrue(StubURLProtocol.requests.isEmpty)
    }

    func testLogoutRevokesTokensOnServerAndClearsKeychain() async throws {
        try accessStore.save("a1")
        try refreshStore.save("r1")
        StubURLProtocol.stubs["/api/v1/app/auth/logout"] = [.init(status: 200, body: #"{"success":true,"code":"SUCCESS","message":"OK"}"#)]

        await session.logout()

        let request = try XCTUnwrap(StubURLProtocol.requests.first)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer a1")
        XCTAssertNil(try accessStore.load())
        XCTAssertNil(try refreshStore.load())
    }
}
