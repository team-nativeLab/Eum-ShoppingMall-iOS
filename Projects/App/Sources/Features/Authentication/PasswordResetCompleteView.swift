import SwiftUI

struct PasswordResetCompleteView: View {
    private let viewModel: PasswordResetCompleteViewModel

    let onClose: () -> Void
    let onLogin: () -> Void

    init(
        viewModel: PasswordResetCompleteViewModel = PasswordResetCompleteViewModel(),
        onClose: @escaping () -> Void,
        onLogin: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
        self.onLogin = onLogin
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            VStack(alignment: .leading, spacing: 0) {
                completionGroup
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text(viewModel.navigationTitle)
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
                .accessibilityLabel("닫기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var completionGroup: some View {
        VStack(spacing: 24) {
            Image("WithdrawalComplete")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 64, height: 64)
                .background(EUMColor.text1SwiftUI, in: Circle())
                .accessibilityHidden(true)
            VStack(spacing: 8) {
                Text(viewModel.title)
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(viewModel.description)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: viewModel.loginButtonTitle, size: .large, action: onLogin)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
