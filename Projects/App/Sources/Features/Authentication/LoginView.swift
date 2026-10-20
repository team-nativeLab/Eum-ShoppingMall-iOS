import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published private(set) var shouldKeepSignedIn = false
    @Published private(set) var showsLoginError: Bool

    init(initialErrorState: Bool = false) {
        email = initialErrorState ? "example@email.com" : ""
        password = initialErrorState ? "password" : ""
        showsLoginError = initialErrorState
    }

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !password.isEmpty
    }

    func toggleKeepSignedIn() {
        shouldKeepSignedIn.toggle()
    }

    func submit() {
        guard canSubmit else { return }
        showsLoginError = true
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

    init(
        onClose: @escaping () -> Void,
        onSignUpTap: @escaping () -> Void,
        onEmailLookupTap: @escaping () -> Void,
        onPasswordLookupTap: @escaping () -> Void,
        initialErrorState: Bool = false
    ) {
        self.onClose = onClose
        self.onSignUpTap = onSignUpTap
        self.onEmailLookupTap = onEmailLookupTap
        self.onPasswordLookupTap = onPasswordLookupTap
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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
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
        VStack(alignment: .leading, spacing: 8) {
            Text("이음산업건설")
                .font(.custom("NotoSansKR-Bold", size: 26))
                .tracking(-0.65)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            HStack(alignment: .top, spacing: 8) {
                Image("LoginInfo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .padding(.top, 2)
                    .accessibilityHidden(true)
                Text("로그인 후 이용할 수 있습니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            .accessibilityElement(children: .combine)
        }
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
                EUMButton(title: "로그인", size: .large) {
                    viewModel.submit()
                }
                .disabled(!viewModel.canSubmit)

                accountLinks
            }
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("비밀번호")
                .font(EUMTypography.labelMedium)
                .tracking(-0.5)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Group {
                    if isPasswordVisible {
                        TextField("비밀번호를 입력해 주세요", text: $viewModel.password)
                    } else {
                        SecureField("비밀번호를 입력해 주세요", text: $viewModel.password)
                    }
                }
                .font(EUMTypography.bodyMedium)
                .tracking(2)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .textContentType(.password)
                .accessibilityLabel("비밀번호")

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isPasswordVisible ? "비밀번호 숨기기" : "비밀번호 표시")
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        viewModel.showsLoginError ? EUMColor.dangerSwiftUI : EUMColor.lineControlSwiftUI,
                        lineWidth: viewModel.showsLoginError ? 1.5 : 1
                    )
            }

            if viewModel.showsLoginError {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 14, weight: .medium))
                        .accessibilityHidden(true)
                    Text("이메일 또는 비밀번호가 일치하지 않습니다. (0/5회)")
                        .font(EUMTypography.captionMedium)
                        .fixedSize(horizontal: true, vertical: false)
                }
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
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .fill(viewModel.shouldKeepSignedIn ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                    .frame(width: 20, height: 20)
                    .overlay {
                        RoundedRectangle(cornerRadius: EUMRadius.small)
                            .stroke(viewModel.shouldKeepSignedIn ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI, lineWidth: 1.5)
                    }
                    .overlay {
                        if viewModel.shouldKeepSignedIn {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
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
                    .font(EUMTypography.captionMedium)
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
