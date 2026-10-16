import Combine
import Foundation

@MainActor
final class EmailLookupViewModel: ObservableObject {
    @Published private(set) var name = "홍길동"
    @Published private(set) var phoneNumber = "010-0000-0000"
    @Published private(set) var verificationCode = ""
    @Published private(set) var remainingSeconds = 179
    @Published private(set) var isPhoneVerified = false

    private let mockVerificationCode = "123456"
    private let mockRegisteredEmail = "example@email.com"

    var canResendCode: Bool {
        phoneDigits.count == 11
    }

    var canVerifyCode: Bool {
        verificationCode.count == 6 && remainingSeconds > 0 && !isPhoneVerified
    }

    var canFindEmail: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && phoneDigits.count == 11
            && isPhoneVerified
    }

    var remainingTimeText: String {
        String(format: "남은 시간 %02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
    }

    private var phoneDigits: String {
        phoneNumber.filter(\.isNumber)
    }

    func updateName(_ value: String) {
        name = value
        resetVerification()
    }

    func updatePhoneNumber(_ value: String) {
        phoneNumber = String(value.filter { $0.isNumber || $0 == "-" }.prefix(13))
        resetVerification()
    }

    func updateVerificationCode(_ value: String) {
        verificationCode = String(value.filter(\.isNumber).prefix(6))
        isPhoneVerified = false
    }

    func resendCode() {
        guard canResendCode else { return }
        remainingSeconds = 179
        verificationCode = ""
        isPhoneVerified = false
    }

    @discardableResult
    func verifyCode() -> Bool {
        isPhoneVerified = canVerifyCode && verificationCode == mockVerificationCode
        return isPhoneVerified
    }

    func findEmail() -> String? {
        guard canFindEmail,
              name.trimmingCharacters(in: .whitespacesAndNewlines) == "홍길동",
              phoneNumber == "010-0000-0000"
        else {
            return nil
        }
        return mockRegisteredEmail
    }

    func tickTimer() {
        guard remainingSeconds > 0, !isPhoneVerified else { return }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            verificationCode = ""
        }
    }

    private func resetVerification() {
        verificationCode = ""
        isPhoneVerified = false
        remainingSeconds = 179
    }
}
