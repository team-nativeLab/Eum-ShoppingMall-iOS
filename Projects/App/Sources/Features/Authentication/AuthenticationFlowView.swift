import SwiftUI

struct AuthenticationFlowView: View {
    private enum Screen {
        case login
        case signUp
        case emailLookup
        case emailLookupResult(String)
        case emailLookupEmpty
        case passwordLookup
        case passwordReset
        case passwordResetComplete
    }

    @State private var screen = Screen.login
    @State private var passwordLookupOrigin = Screen.login
    @State private var presentedMessage: String?
    let onClose: () -> Void

    var body: some View {
        Group {
            switch screen {
            case .login:
                LoginView(
                    onClose: onClose,
                    onSignUpTap: { screen = .signUp },
                    onEmailLookupTap: { screen = .emailLookup },
                    onPasswordLookupTap: showPasswordLookup
                )
            case .signUp:
                SignUpView(onBack: { screen = .login })
            case .emailLookup:
                EmailLookupView(
                    onBack: { screen = .login },
                    onPasswordLookup: showPasswordLookup,
                    onFindEmail: { email in
                        if let email {
                            screen = .emailLookupResult(email)
                        } else {
                            screen = .emailLookupEmpty
                        }
                    }
                )
            case let .emailLookupResult(email):
                EmailLookupResultView(
                    email: email,
                    onClose: onClose,
                    onLogin: { screen = .login },
                    onPasswordLookup: showPasswordLookup
                )
            case .emailLookupEmpty:
                EmailLookupEmptyView(
                    onClose: onClose,
                    onFindAgain: { screen = .emailLookup },
                    onSignUp: { screen = .signUp }
                )
            case .passwordLookup:
                PasswordLookupView(
                    onBack: { screen = passwordLookupOrigin },
                    onContinue: { screen = .passwordReset }
                )
            case .passwordReset:
                PasswordResetView(
                    onBack: { screen = .passwordLookup },
                    onContinue: { screen = .passwordResetComplete }
                )
            case .passwordResetComplete:
                PasswordResetCompleteView(
                    onClose: onClose,
                    onLogin: { screen = .login }
                )
            }
        }
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private func showPasswordLookup() {
        passwordLookupOrigin = screen
        screen = .passwordLookup
    }

    private var messagePresented: Binding<Bool> {
        Binding(get: { presentedMessage != nil }, set: { if !$0 { presentedMessage = nil } })
    }
}

struct AuthenticationFlowViewPreview: PreviewProvider {
    static var previews: some View {
        AuthenticationFlowView(onClose: {})
    }
}
