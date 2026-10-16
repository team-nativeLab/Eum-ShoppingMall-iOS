import SwiftUI

struct AuthenticationFlowView: View {
    private enum Screen {
        case login
        case signUp
        case emailLookup
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
                    onPasswordLookup: { presentedMessage = "비밀번호 찾기는 별도 화면 작업에서 연결할 예정이에요." },
                    onFindEmail: { email in
                        presentedMessage = email.map { "가입된 이메일은 \($0)입니다." } ?? "가입 정보를 찾을 수 없어요."
                    }
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
