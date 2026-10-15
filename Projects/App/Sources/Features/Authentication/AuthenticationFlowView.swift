import SwiftUI

struct AuthenticationFlowView: View {
    private enum Screen {
        case login
        case signUp
    }

    @State private var screen = Screen.login
    let onClose: () -> Void

    var body: some View {
        Group {
            switch screen {
            case .login:
                LoginView(onClose: onClose, onSignUpTap: { screen = .signUp })
            case .signUp:
                SignUpView(onBack: { screen = .login })
            }
        }
    }
}

struct AuthenticationFlowViewPreview: PreviewProvider {
    static var previews: some View {
        AuthenticationFlowView(onClose: {})
    }
}
