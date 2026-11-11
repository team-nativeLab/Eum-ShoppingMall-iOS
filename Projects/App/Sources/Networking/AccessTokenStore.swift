import Foundation
import Security

struct AccessTokenStore {
    private let service: String
    private let account = "member-access-token"

    init(service: String = Bundle.main.bundleIdentifier ?? "EumShoppingMall") {
        self.service = service
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
