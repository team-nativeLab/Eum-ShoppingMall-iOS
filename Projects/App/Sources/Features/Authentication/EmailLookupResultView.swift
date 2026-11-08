import SwiftUI

struct EmailLookupResultView: View {
    @StateObject private var viewModel: EmailLookupResultViewModel

    let onClose: () -> Void
    let onLogin: () -> Void
    let onPasswordLookup: () -> Void

    init(
        email: String,
        onClose: @escaping () -> Void,
        onLogin: @escaping () -> Void,
        onPasswordLookup: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: EmailLookupResultViewModel(email: email))
        self.onClose = onClose
        self.onLogin = onLogin
        self.onPasswordLookup = onPasswordLookup
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            VStack(alignment: .leading, spacing: 24) {
                resultHeader
                accountSummary
                privacyNotice
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomActions
        }
    }

    private var topBar: some View {
        ZStack {
            Text("계정 찾기")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("계정 찾기 닫기")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var resultHeader: some View {
        VStack(spacing: 24) {
            Image("WithdrawalComplete")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 64, height: 64)
                .background(EUMColor.text1SwiftUI, in: Circle())
                .accessibilityHidden(true)
            VStack(spacing: 8) {
                Text("이메일을 찾았습니다")
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.isHeader)
                Text("\(viewModel.name)님의 휴대폰 번호로 가입된 계정입니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var accountSummary: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.maskedEmail)
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("가입일 \(viewModel.joinedAt)")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.memberType)
                .font(EUMTypography.labelExtraSmall)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .padding(.horizontal, 6)
                .frame(height: 20)
                .background(EUMColor.surfaceSecondarySwiftUI, in: RoundedRectangle(cornerRadius: 4))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var privacyNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("LoginInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
                .accessibilityHidden(true)
            Text("개인정보 보호를 위해 이메일 일부를 *로 표시합니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }

    private var bottomActions: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            HStack(spacing: 8) {
                EUMButton(title: "로그인", kind: .primary, size: .large, action: onLogin)
                EUMButton(title: "비밀번호 찾기", kind: .secondary, size: .large, action: onPasswordLookup)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
