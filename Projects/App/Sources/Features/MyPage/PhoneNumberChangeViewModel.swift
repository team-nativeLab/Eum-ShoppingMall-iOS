import Combine
import Foundation

@MainActor
final class PhoneNumberChangeViewModel: ObservableObject {
    @Published private(set) var currentPhoneNumber: String
    @Published private(set) var newPhoneNumber = "010-0000-0000"
    @Published private(set) var verificationCode = ""
    @Published private(set) var remainingSeconds = 179
    @Published private(set) var isPhoneVerified = false

    private let mockVerificationCode = "123456"

    init(currentPhoneNumber: String) {
        self.currentPhoneNumber = currentPhoneNumber
    }

    var canResendCode: Bool {
        phoneDigits.count == 11
    }

    var canVerifyCode: Bool {
        verificationCode.count == 6 && remainingSeconds > 0 && !isPhoneVerified
    }

    var canChangePhoneNumber: Bool {
        phoneDigits.count == 11 && isPhoneVerified
    }

    var remainingTimeText: String {
        String(format: "남은 시간 %02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
    }

    private var phoneDigits: String {
        newPhoneNumber.filter(\.isNumber)
    }

    func updateNewPhoneNumber(_ value: String) {
        let digits = String(value.filter(\.isNumber).prefix(11))
        switch digits.count {
        case 0...3:
            newPhoneNumber = digits
        case 4...7:
            newPhoneNumber = "\(digits.prefix(3))-\(digits.dropFirst(3))"
        default:
            newPhoneNumber = "\(digits.prefix(3))-\(digits.dropFirst(3).prefix(4))-\(digits.suffix(4))"
        }
        resetVerification()
    }

    func updateVerificationCode(_ value: String) {
        verificationCode = String(value.filter(\.isNumber).prefix(6))
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

    func changedPhoneNumber() -> String? {
        canChangePhoneNumber ? newPhoneNumber : nil
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
