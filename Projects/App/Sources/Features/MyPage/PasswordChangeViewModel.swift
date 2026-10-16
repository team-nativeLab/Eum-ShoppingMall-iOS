import Combine
import Foundation

@MainActor
final class PasswordChangeViewModel: ObservableObject {
    @Published var currentPassword = "WrongPass1"
    @Published var newPassword = "NewPass123"
    @Published var passwordConfirmation = "NewPass123"
    @Published var isCurrentPasswordVisible = false
    @Published var isNewPasswordVisible = false
    @Published var isConfirmationVisible = false

    private let mockCurrentPassword = "Current123"

    var isCurrentPasswordValid: Bool {
        currentPassword == mockCurrentPassword
    }

    var isNewPasswordValid: Bool {
        newPassword.count >= 8
            && newPassword.contains(where: \.isLetter)
            && newPassword.contains(where: \.isNumber)
    }

    var passwordsMatch: Bool {
        newPassword == passwordConfirmation
    }

    var canChangePassword: Bool {
        isNewPasswordValid && passwordsMatch
    }

    func submitMessage() -> String {
        isCurrentPasswordValid
            ? "비밀번호 변경은 계정 서비스 연동 후 이용할 수 있어요."
            : "현재 비밀번호가 일치하지 않습니다. 다시 입력해 주세요."
    }
}
