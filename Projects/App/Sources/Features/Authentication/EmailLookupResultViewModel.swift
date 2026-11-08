import Combine
import Foundation

@MainActor
final class EmailLookupResultViewModel: ObservableObject {
    let name = "홍길동"
    let joinedAt = "0000.00.00"
    let memberType = "개인 회원"

    private let email: String

    init(email: String) {
        self.email = email
    }

    var maskedEmail: String {
        Self.mask(email)
    }

    static func mask(_ email: String) -> String {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else { return "***" }
        return "\(parts[0].prefix(2))***@\(parts[1])"
    }
}
