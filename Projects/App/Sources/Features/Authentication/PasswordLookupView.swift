import SwiftUI

struct PasswordLookupView: View {
    @StateObject private var viewModel = PasswordLookupViewModel()

    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    lookupTabs
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
            Text("계정 찾기")
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
                .accessibilityLabel("이메일 찾기로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var lookupTabs: some View {
        HStack(spacing: 4) {
            tabButton(title: "이메일 찾기", isSelected: false, action: onBack)
            tabButton(title: "비밀번호 찾기", isSelected: true) {}
        }
        .padding(4)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 8))
    }

    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(EUMColor.backgroundSwiftUI)
                            .shadow(color: EUMColor.text1SwiftUI.opacity(0.06), radius: 3, x: 0, y: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일과 휴대폰 번호를\n입력해 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            Text("본인 확인 후 새 비밀번호를 설정할 수 있습니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("이메일")
                TextField("이메일", text: emailBinding)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                    .accessibilityLabel("이메일")
            }
            phoneVerification
        }
    }

    private var phoneVerification: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    fieldLabel("휴대폰 번호")
                    TextField("휴대폰 번호", text: .constant(viewModel.phoneNumber))
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.textDisabledSwiftUI)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
                        .disabled(true)
                        .accessibilityLabel("휴대폰 번호")
                }
                EUMButton(title: "재전송", kind: .secondary, size: .medium) {}
                    .frame(width: 72)
                    .disabled(true)
            }
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("인증번호 6자리", text: .constant(viewModel.verificationCode))
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.text3SwiftUI, lineWidth: 1))
                        .disabled(true)
                        .accessibilityLabel("인증 완료된 인증번호")
                    HStack(spacing: 4) {
                        Image("PasswordLookupVerified")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .accessibilityHidden(true)
                        Text("인증되었습니다.")
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(Color(red: 30 / 255, green: 122 / 255, blue: 60 / 255))
                    }
                }
                EUMButton(title: "확인", kind: .secondary, size: .medium) {}
                    .frame(width: 72)
                    .disabled(true)
            }
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: "다음", size: .large) {
                onContinue()
            }
            .disabled(!viewModel.canContinue)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }

    private func fieldLabel(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelMedium)
            .tracking(-0.07)
            .foregroundStyle(EUMColor.text1SwiftUI)
    }

    private var emailBinding: Binding<String> {
        Binding(get: { viewModel.email }, set: viewModel.updateEmail)
    }
}
