import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    static let maximumFailures = 5

    @Published var email: String
    @Published var password: String
    @Published private(set) var shouldKeepSignedIn = false
    @Published private(set) var showsLoginError: Bool
    @Published private(set) var failureCount = 0
    @Published private(set) var isSubmitting = false
    @Published var alertMessage: String?

    private let login: (String, String) async throws -> Void

    init(
        initialErrorState: Bool = false,
        login: ((String, String) async throws -> Void)? = nil
    ) {
        email = initialErrorState ? "example@email.com" : ""
        password = initialErrorState ? "password" : ""
        showsLoginError = initialErrorState
        self.login = login ?? { email, password in
            try await AppServices.shared.login(email: email, password: password)
        }
    }

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !password.isEmpty
            && !isSubmitting
    }

    /// Server does not report remaining attempts, so the screen counts failed tries (Figma `(n/5회)`).
    var errorText: String {
        "이메일 또는 비밀번호가 일치하지 않습니다. (\(failureCount)/\(Self.maximumFailures)회)"
    }

    func toggleKeepSignedIn() {
        shouldKeepSignedIn.toggle()
    }

    /// Returns `true` when the server accepted the credentials and tokens were stored.
    @discardableResult
    func submit() async -> Bool {
        guard canSubmit else { return false }
        isSubmitting = true
        defer { isSubmitting = false }
        do {
            try await login(email.trimmingCharacters(in: .whitespacesAndNewlines), password)
            showsLoginError = false
            failureCount = 0
            return true
        } catch {
            handle(error)
            return false
        }
    }

    private func handle(_ error: Error) {
        switch error {
        case let APIClientError.httpFailure(_, payload) where payload?.code == "LOGIN_FAILED":
            failureCount = min(failureCount + 1, Self.maximumFailures)
            showsLoginError = true
        case let APIClientError.httpFailure(_, payload) where payload?.code == "LOGIN_LOCKED":
            alertMessage = payload?.message ?? "로그인 시도가 많아 잠시 제한되었습니다. 10분 후 다시 시도해 주세요."
        case let APIClientError.httpFailure(_, payload) where payload?.code == "CAPTCHA_REQUIRED":
            alertMessage = payload?.message ?? "여러 번 틀렸습니다. 로봇이 아님을 확인해 주세요."
        case let APIClientError.httpFailure(_, payload):
            alertMessage = payload?.message ?? "로그인하지 못했습니다. 잠시 후 다시 시도해 주세요."
        case is URLError:
            alertMessage = "네트워크 연결을 확인한 뒤 다시 시도해 주세요."
        default:
            alertMessage = "로그인하지 못했습니다. 잠시 후 다시 시도해 주세요."
        }
    }
}

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var isPasswordVisible = false
    @State private var presentedMessage: String?

    let onClose: () -> Void
    var onSignUpTap: () -> Void
    var onEmailLookupTap: () -> Void
    var onPasswordLookupTap: () -> Void
    var onLoginSuccess: () -> Void

    init(
        onClose: @escaping () -> Void,
        onSignUpTap: @escaping () -> Void,
        onEmailLookupTap: @escaping () -> Void,
        onPasswordLookupTap: @escaping () -> Void,
        onLoginSuccess: (() -> Void)? = nil,
        initialErrorState: Bool = false
    ) {
        self.onClose = onClose
        self.onSignUpTap = onSignUpTap
        self.onEmailLookupTap = onEmailLookupTap
        self.onPasswordLookupTap = onPasswordLookupTap
        self.onLoginSuccess = onLoginSuccess ?? onClose
        _viewModel = StateObject(wrappedValue: LoginViewModel(initialErrorState: initialErrorState))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                loginContent
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil || viewModel.alertMessage != nil },
            set: { if !$0 { presentedMessage = nil; viewModel.alertMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil; viewModel.alertMessage = nil }
        } message: {
            Text(viewModel.alertMessage ?? presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("로그인")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Button(action: onClose) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("로그인 닫기")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var loginContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            brandSection
            loginForm
            alternateActions
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }

    private var brandSection: some View {
        Text("안전맛집")
            .font(.custom(EUMFontName.bold, size: 26))
            .tracking(-0.65)
            .frame(height: 34)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .accessibilityAddTraits(.isHeader)
    }

    private var loginForm: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                EUMTextField(title: "이메일", placeholder: "이메일을 입력해 주세요", text: $viewModel.email)
                    .textContentType(.username)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                VStack(alignment: .leading, spacing: 16) {
                    passwordField
                    keepSignedInToggle
                }
            }

            VStack(spacing: 16) {
                EUMButton(title: viewModel.isSubmitting ? "로그인 중…" : "로그인", size: .large) {
                    Task {
                        if await viewModel.submit() {
                            onLoginSuccess()
                        }
                    }
                }
                .disabled(!viewModel.canSubmit)

                accountLinks
            }
        }
    }

    private var passwordBorderWidth: CGFloat {
        viewModel.showsLoginError ? 1.5 : 1
    }

    private var passwordPrompt: Text {
        Text("비밀번호를 입력해 주세요")
            .tracking(-0.075)
            .foregroundColor(EUMColor.text3SwiftUI)
    }

    private var passwordVisibilityToggle: some View {
        Button {
            isPasswordVisible.toggle()
        } label: {
            Group {
                if isPasswordVisible {
                    Image(systemName: "eye")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(EUMColor.text3SwiftUI)
                } else {
                    Image("LoginPasswordHidden")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .frame(width: 20, height: 20)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isPasswordVisible ? "비밀번호 숨기기" : "비밀번호 표시")
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Group {
                    if isPasswordVisible {
                        TextField("", text: $viewModel.password, prompt: passwordPrompt)
                    } else {
                        SecureField("", text: $viewModel.password, prompt: passwordPrompt)
                    }
                }
                .font(EUMTypography.bodyMedium)
                .tracking(2)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .textContentType(.password)
                .accessibilityLabel("비밀번호")

                // A-13 (empty) has no trailing icon; A-13e (filled) shows the visibility toggle.
                if !viewModel.password.isEmpty {
                    passwordVisibilityToggle
                }
            }
            // Figma uses border-box sizing: content starts after the border plus 14 pt padding.
            .padding(.horizontal, 14 + passwordBorderWidth)
            .frame(height: 48)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        viewModel.showsLoginError ? EUMColor.dangerSwiftUI : EUMColor.lineControlSwiftUI,
                        lineWidth: passwordBorderWidth
                    )
            }

            if viewModel.showsLoginError {
                HStack(spacing: 4) {
                    Image("LoginErrorAlert")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .accessibilityHidden(true)
                    Text(viewModel.errorText)
                        .font(EUMTypography.captionRegular)
                        .fixedSize(horizontal: true, vertical: false)
                }
                // HF/Caption line height is 16 pt; the font's natural line is taller.
                .frame(height: 16)
                .foregroundStyle(EUMColor.dangerSwiftUI)
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var keepSignedInToggle: some View {
        Button {
            viewModel.toggleKeepSignedIn()
        } label: {
            HStack(spacing: 10) {
                // Figma HF/Checkbox: 16 pt, 4 pt radius, 1.5 pt line-control border on surface-2.
                RoundedRectangle(cornerRadius: 4)
                    .fill(viewModel.shouldKeepSignedIn ? EUMColor.text1SwiftUI : EUMColor.surfaceSecondarySwiftUI)
                    .frame(width: 16, height: 16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(
                                viewModel.shouldKeepSignedIn ? EUMColor.text1SwiftUI : EUMColor.lineControlSwiftUI,
                                lineWidth: 1.5
                            )
                    }
                    .overlay {
                        if viewModel.shouldKeepSignedIn {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(EUMColor.inverseSwiftUI)
                        }
                    }
                    .accessibilityHidden(true)
                Text("로그인 상태 유지")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 0)
            }
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("로그인 상태 유지")
        .accessibilityValue(viewModel.shouldKeepSignedIn ? "켜짐" : "꺼짐")
    }

    private var accountLinks: some View {
        HStack(spacing: 12) {
            accountLink("이메일 찾기", action: onEmailLookupTap)
            linkDivider
            accountLink("비밀번호 찾기", action: onPasswordLookupTap)
            linkDivider
            accountLink("회원가입", emphasized: true, action: onSignUpTap)
        }
        .frame(maxWidth: .infinity)
    }

    private var linkDivider: some View {
        Rectangle()
            .fill(EUMColor.lineStrongSwiftUI)
            .frame(width: 1, height: 12)
            .accessibilityHidden(true)
    }

    private func accountLink(_ title: String, emphasized: Bool = false, action: (() -> Void)? = nil) -> some View {
        Button {
            if let action {
                action()
            } else {
                presentedMessage = "\(title) 화면은 아직 연결되지 않았어요."
            }
        } label: {
            Text(title)
                .font(emphasized ? EUMTypography.labelMedium : EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(emphasized ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private var alternateActions: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                Text("또는")
                    .font(EUMTypography.captionRegular)
                    .frame(height: 16)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            }

            VStack(spacing: 8) {
                EUMButton(title: "간편로그인 A", kind: .secondary, size: .medium) {
                    presentedMessage = "간편로그인 A는 아직 연결되지 않았어요."
                }
                EUMButton(title: "간편로그인 B", kind: .secondary, size: .medium) {
                    presentedMessage = "간편로그인 B는 아직 연결되지 않았어요."
                }
            }
        }
    }
}

struct LoginViewPreview: PreviewProvider {
    static var previews: some View {
        LoginView(
            onClose: {},
            onSignUpTap: {},
            onEmailLookupTap: {},
            onPasswordLookupTap: {},
            initialErrorState: true
        )
    }
}
