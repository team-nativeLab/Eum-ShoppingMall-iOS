import Foundation
import Security

/// Abstraction over token persistence so tests and unsigned simulator builds can avoid the Keychain.
protocol TokenStoring: Sendable {
    func save(_ token: String) throws
    func load() throws -> String?
    func remove() throws
}

struct AccessTokenStore: TokenStoring {
    static let accessTokenAccount = "member-access-token"
    static let refreshTokenAccount = "member-refresh-token"

    private let service: String
    private let account: String

    init(
        service: String = Bundle.main.bundleIdentifier ?? "EumShoppingMall",
        account: String = AccessTokenStore.accessTokenAccount
    ) {
        self.service = service
        self.account = account
    }

    func save(_ token: String) throws {
        let data = Data(token.utf8)
        let query = baseQuery
        let updateAttributes = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)

        if updateStatus == errSecItemNotFound {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw AccessTokenStoreError.keychainStatus(addStatus)
            }
        } else if updateStatus != errSecSuccess {
            throw AccessTokenStoreError.keychainStatus(updateStatus)
        }
    }

    func load() throws -> String? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound {
            return nil
        }
        guard status == errSecSuccess, let data = result as? Data else {
            throw AccessTokenStoreError.keychainStatus(status)
        }
        return String(data: data, encoding: .utf8)
    }

    func remove() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AccessTokenStoreError.keychainStatus(status)
        }
    }

    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
}

enum AccessTokenStoreError: Error {
    case keychainStatus(OSStatus)
}

/// Process-lifetime token storage used by tests and as a fallback when the Keychain is unavailable.
final class InMemoryTokenStore: TokenStoring, @unchecked Sendable {
    private let lock = NSLock()
    private var token: String?

    init(token: String? = nil) {
        self.token = token
    }

    func save(_ token: String) throws {
        lock.withLock { self.token = token }
    }

    func load() throws -> String? {
        lock.withLock { token }
    }

    func remove() throws {
        lock.withLock { token = nil }
    }
}

/// Uses the Keychain, falling back to memory when the build has no Keychain entitlement
/// (`errSecMissingEntitlement`, e.g. unsigned simulator builds with CODE_SIGNING_ALLOWED=NO).
struct KeychainFallbackTokenStore: TokenStoring {
    private let keychain: AccessTokenStore
    private let memory = InMemoryTokenStore()

    init(account: String) {
        keychain = AccessTokenStore(account: account)
    }

    func save(_ token: String) throws {
        do {
            try keychain.save(token)
        } catch AccessTokenStoreError.keychainStatus(errSecMissingEntitlement) {
            try memory.save(token)
        }
    }

    func load() throws -> String? {
        do {
            return try keychain.load()
        } catch AccessTokenStoreError.keychainStatus(errSecMissingEntitlement) {
            return try memory.load()
        }
    }

    func remove() throws {
        do {
            try keychain.remove()
        } catch AccessTokenStoreError.keychainStatus(errSecMissingEntitlement) {
            try memory.remove()
        }
        try memory.remove()
    }
}
