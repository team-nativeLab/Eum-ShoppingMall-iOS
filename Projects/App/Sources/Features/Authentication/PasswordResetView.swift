import SwiftUI

struct PasswordResetView: View {
    @StateObject private var viewModel = PasswordResetViewModel()

    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    introduction
                    fields
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text("비밀번호 재설정")
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
                .accessibilityLabel("비밀번호 찾기로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("새 비밀번호를\n설정해 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            Text("다른 사이트와 다른 비밀번호를 사용해 주세요.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 16) {
            passwordField(
                title: "새 비밀번호",
                text: $viewModel.password,
                isVisible: $viewModel.isPasswordVisible,
                showsMismatch: false
            )
            passwordField(
                title: "새 비밀번호 확인",
                text: $viewModel.passwordConfirmation,
                isVisible: $viewModel.isConfirmationVisible,
                showsMismatch: !viewModel.passwordsMatch
            )
        }
    }

    private func passwordField(
        title: String,
        text: Binding<String>,
        isVisible: Binding<Bool>,
        showsMismatch: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack(spacing: 8) {
                Group {
                    if isVisible.wrappedValue {
                        TextField(title, text: text)
                    } else {
                        SecureField(title, text: text)
                    }
                }
                .textContentType(.newPassword)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(EUMTypography.bodyMedium)
                .tracking(2)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityLabel(title)

                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image("WithdrawalPasswordVisibility")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isVisible.wrappedValue ? "비밀번호 숨기기" : "비밀번호 보기")
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        showsMismatch ? EUMColor.dangerSwiftUI : EUMColor.lineControlSwiftUI,
                        lineWidth: showsMismatch ? 1.5 : 1
                    )
            }

            if showsMismatch {
                HStack(spacing: 4) {
                    Image("WithdrawalPasswordError")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .accessibilityHidden(true)
                    Text("비밀번호가 서로 일치하지 않습니다.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                }
                .accessibilityElement(children: .combine)
            } else {
                Text("영문·숫자 조합 8자 이상")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: "변경하기", size: .large, action: onContinue)
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
