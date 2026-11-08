import Combine
import Foundation

@MainActor
final class PasswordLookupViewModel: ObservableObject {
    @Published private(set) var email = "example@email.com"
    @Published private(set) var phoneNumber = "010-0000-0000"
    @Published private(set) var verificationCode = "000000"
    @Published private(set) var isPhoneVerified = true

    var canContinue: Bool {
        email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil
            && isPhoneVerified
    }

    func updateEmail(_ value: String) {
        email = value
    }

    func continueLookup() -> String? {
        canContinue ? email : nil
    }
}
