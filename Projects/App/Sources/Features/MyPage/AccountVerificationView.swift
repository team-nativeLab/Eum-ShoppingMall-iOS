import SwiftUI

@MainActor
final class AccountVerificationViewModel: ObservableObject {
    @Published var password = ""
    @Published private(set) var isPasswordInvalid = false

    let email = "example@email.com"
    private let mockValidPassword = "password"

    func requestVerification() -> String? {
        guard !password.isEmpty else { return "비밀번호를 입력해 주세요." }
        isPasswordInvalid = password != mockValidPassword
        return nil
    }

    func clearPasswordError() {
        isPasswordInvalid = false
    }
}

struct AccountVerificationView: View {
    @StateObject private var viewModel: AccountVerificationViewModel

    let onBack: () -> Void
    let onConfirm: (String?) -> Void

    init(onBack: @escaping () -> Void, onConfirm: @escaping (String?) -> Void) {
        self.init(onBack: onBack, onConfirm: onConfirm, viewModel: AccountVerificationViewModel())
    }

    init(
        onBack: @escaping () -> Void,
        onConfirm: @escaping (String?) -> Void,
        viewModel: AccountVerificationViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onConfirm = onConfirm
    }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 44)
            topBar
            ScrollView {
                VStack(spacing: 24) {
                    introduction
                    fields
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
        .onChange(of: viewModel.password) { _, _ in
            viewModel.clearPasswordError()
        }
    }

    private var topBar: some View {
        ZStack {
            Text("내 정보 관리")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("마이페이지로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(spacing: 12) {
            Image("AccountVerificationLock")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .frame(width: 64, height: 64)
                .background(EUMColor.backgroundSubtleSwiftUI, in: Circle())
                .accessibilityHidden(true)

            Text("비밀번호를 다시 입력해 주세요")
                .font(EUMTypography.heading3)
                .tracking(-0.27)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)

            Text("회원님의 정보를 안전하게 보호하기 위해\n한 번 더 확인합니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var fields: some View {
        VStack(spacing: 16) {
            AccountVerificationField(title: "이메일", placeholder: viewModel.email, text: .constant(""), isDisabled: true)
            AccountVerificationField(
                title: "비밀번호",
                placeholder: "비밀번호를 입력해 주세요",
                text: $viewModel.password,
                isSecure: true,
                errorMessage: viewModel.isPasswordInvalid ? "비밀번호가 일치하지 않습니다." : nil
            )
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "확인", size: .large) {
                let message = viewModel.requestVerification()
                if !viewModel.isPasswordInvalid {
                    onConfirm(message)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}

private struct AccountVerificationField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    var isDisabled = false
    var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            field
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text3SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(isDisabled ? EUMColor.surfaceSwiftUI : EUMColor.backgroundSwiftUI)
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(borderColor, lineWidth: errorMessage == nil ? 1 : 1.5)
                }

            if let errorMessage {
                HStack(spacing: 4) {
                    Image("WithdrawalPasswordError")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .accessibilityHidden(true)
                    Text(errorMessage)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var borderColor: Color {
        if errorMessage != nil { return EUMColor.dangerSwiftUI }
        return isDisabled ? EUMColor.lineSwiftUI : EUMColor.lineStrongSwiftUI
    }

    @ViewBuilder
    private var field: some View {
        if isSecure {
            SecureField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(EUMColor.text3SwiftUI))
                .accessibilityLabel(title)
        } else {
            TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(EUMColor.textDisabledSwiftUI))
                .disabled(isDisabled)
                .accessibilityLabel(title)
        }
    }
}

struct AccountVerificationViewPreview: PreviewProvider {
    static var previews: some View {
        let viewModel = AccountVerificationViewModel()
        viewModel.password = "wrong-password"
        _ = viewModel.requestVerification()
        return AccountVerificationView(onBack: {}, onConfirm: { _ in }, viewModel: viewModel)
    }
}
