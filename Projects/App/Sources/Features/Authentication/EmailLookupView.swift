import Combine
import SwiftUI

struct EmailLookupView: View {
    @StateObject private var viewModel = EmailLookupViewModel()
    @State private var presentedMessage: String?

    let onBack: () -> Void
    let onPasswordLookup: () -> Void
    let onFindEmail: (String?) -> Void

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    lookupTabs
                    introduction
                    fields
                    supportMessage
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
        .onReceive(timer) { _ in viewModel.tickTimer() }
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
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
                .accessibilityLabel("로그인으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var lookupTabs: some View {
        HStack(spacing: 4) {
            tabButton(title: "이메일 찾기", isSelected: true) {}
            tabButton(title: "비밀번호 찾기", isSelected: false, action: onPasswordLookup)
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
            Text("이름과 휴대폰 번호를\n입력해 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            Text("가입할 때 입력한 정보로 이메일을 찾을 수 있습니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("이름")
                TextField("이름", text: nameBinding)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                    .accessibilityLabel("이름")
            }
            phoneVerification
        }
    }

    private var phoneVerification: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    fieldLabel("휴대폰 번호")
                    TextField("휴대폰 번호", text: phoneNumberBinding)
                        .keyboardType(.phonePad)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                        .accessibilityLabel("휴대폰 번호")
                }
                EUMButton(title: "재전송", kind: .secondary, size: .medium) {
                    viewModel.resendCode()
                }
                .frame(width: 72)
                .disabled(!viewModel.canResendCode)
            }
            HStack(alignment: .top, spacing: 8) {
                TextField("인증번호 6자리", text: verificationCodeBinding)
                    .keyboardType(.numberPad)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.text1SwiftUI, lineWidth: 1.5))
                    .accessibilityLabel("인증번호 6자리")
                EUMButton(title: "확인", kind: .secondary, size: .medium) {
                    if !viewModel.verifyCode() {
                        presentedMessage = "인증번호를 다시 확인해 주세요."
                    }
                }
                .frame(width: 72)
                .disabled(!viewModel.canVerifyCode)
            }
            Text(viewModel.remainingTimeText)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var supportMessage: some View {
        Text("휴대폰 번호가 바뀌었다면 고객센터 0000-0000으로 문의해 주세요.")
            .font(EUMTypography.captionRegular)
            .foregroundStyle(EUMColor.text3SwiftUI)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: "이메일 찾기", size: .large) {
                onFindEmail(viewModel.findEmail())
            }
            .disabled(!viewModel.canFindEmail)
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

    private var nameBinding: Binding<String> {
        Binding(get: { viewModel.name }, set: viewModel.updateName)
    }

    private var phoneNumberBinding: Binding<String> {
        Binding(get: { viewModel.phoneNumber }, set: viewModel.updatePhoneNumber)
    }

    private var verificationCodeBinding: Binding<String> {
        Binding(get: { viewModel.verificationCode }, set: viewModel.updateVerificationCode)
    }

    private var messagePresented: Binding<Bool> {
        Binding(get: { presentedMessage != nil }, set: { if !$0 { presentedMessage = nil } })
    }
}
