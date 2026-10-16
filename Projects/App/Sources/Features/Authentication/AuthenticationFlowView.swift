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
    }

    @State private var screen = Screen.login
    @State private var presentedMessage: String?
    let onClose: () -> Void

    var body: some View {
        Group {
            switch screen {
            case .login:
                LoginView(
                    onClose: onClose,
                    onSignUpTap: { screen = .signUp },
                    onEmailLookupTap: { screen = .emailLookup }
                )
            case .signUp:
                SignUpView(onBack: { screen = .login })
            case .emailLookup:
                EmailLookupView(
                    onBack: { screen = .login },
                    onPasswordLookup: { screen = .passwordLookup },
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
                    onPasswordLookup: { screen = .passwordLookup }
                )
            case .emailLookupEmpty:
                EmailLookupEmptyView(
                    onClose: onClose,
                    onFindAgain: { screen = .emailLookup },
                    onSignUp: { screen = .signUp }
                )
            case .passwordLookup:
                PasswordLookupView(
                    onBack: { screen = .emailLookup },
                    onContinue: { screen = .passwordReset }
                )
            case .passwordReset:
                PasswordResetView(
                    onBack: { screen = .passwordLookup },
                    onContinue: { presentedMessage = "비밀번호 변경 완료 화면은 다음 단계에서 연결됩니다." }
                )
            }
        }
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
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
