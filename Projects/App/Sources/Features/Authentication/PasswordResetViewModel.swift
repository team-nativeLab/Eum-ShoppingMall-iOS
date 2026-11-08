import Combine
import Foundation

@MainActor
final class PasswordResetViewModel: ObservableObject {
    @Published var password = "Abcd1234"
    @Published var passwordConfirmation = "Abcd123"
    @Published var isPasswordVisible = false
    @Published var isConfirmationVisible = false

    var isPasswordValid: Bool {
        password.count >= 8
            && password.contains(where: \.isLetter)
            && password.contains(where: \.isNumber)
    }

    var passwordsMatch: Bool {
        !passwordConfirmation.isEmpty && passwordConfirmation == password
    }

    var canSubmit: Bool {
        isPasswordValid && passwordsMatch
    }
}
