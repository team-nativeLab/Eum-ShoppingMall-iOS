import Combine
import SwiftUI

struct PhoneNumberChangeView: View {
    @StateObject private var viewModel: PhoneNumberChangeViewModel
    @State private var presentedMessage: String?

    let onBack: () -> Void
    let onChange: (String) -> Void

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(currentPhoneNumber: String, onBack: @escaping () -> Void, onChange: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: PhoneNumberChangeViewModel(currentPhoneNumber: currentPhoneNumber))
        self.onBack = onBack
        self.onChange = onChange
    }

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
        .onReceive(timer) { _ in viewModel.tickTimer() }
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("휴대폰 번호 변경")
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
                .accessibilityLabel("내 정보 수정으로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("새 휴대폰 번호를\n인증해 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            Text("변경한 번호로 주문·배송 알림을 보내 드립니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                fieldLabel("현재 휴대폰 번호")
                TextField("현재 휴대폰 번호", text: .constant(viewModel.currentPhoneNumber))
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.textDisabledSwiftUI)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
                    .disabled(true)
                    .accessibilityLabel("현재 휴대폰 번호")
            }
            phoneVerification
        }
    }

    private var phoneVerification: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    fieldLabel("새 휴대폰 번호")
                    TextField("휴대폰 번호", text: phoneNumberBinding)
                        .keyboardType(.phonePad)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                        .accessibilityLabel("새 휴대폰 번호")
                }
                EUMButton(title: "재전송", kind: .secondary, size: .medium) {
                    viewModel.resendCode()
                }
                .frame(width: 72)
                .disabled(!viewModel.canResendCode || viewModel.isPhoneVerified)
            }
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField("인증번호 6자리", text: verificationCodeBinding)
                        .keyboardType(.numberPad)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .padding(.horizontal, 14)
                        .frame(height: 48)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    viewModel.isPhoneVerified ? EUMColor.lineControlSwiftUI : EUMColor.text1SwiftUI,
                                    lineWidth: viewModel.isPhoneVerified ? 1 : 1.5
                                )
                        }
                        .disabled(viewModel.isPhoneVerified)
                        .accessibilityLabel("인증번호 6자리")
                    if viewModel.isPhoneVerified {
                        HStack(spacing: 4) {
                            Image("PasswordLookupVerified")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .accessibilityHidden(true)
                            Text("인증되었습니다.")
                                .font(EUMTypography.captionRegular)
                                .foregroundStyle(Color(red: 30 / 255, green: 122 / 255, blue: 60 / 255))
                        }
                    } else {
                        Text(viewModel.remainingTimeText)
                            .font(EUMTypography.captionRegular)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                    }
                }
                EUMButton(title: "확인", kind: .secondary, size: .medium) {
                    if !viewModel.verifyCode() {
                        presentedMessage = "인증번호를 다시 확인해 주세요."
                    }
                }
                .frame(width: 60)
                .disabled(!viewModel.canVerifyCode)
            }
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            EUMButton(title: "변경하기", size: .large) {
                if let phoneNumber = viewModel.changedPhoneNumber() {
                    onChange(phoneNumber)
                }
            }
            .disabled(!viewModel.canChangePhoneNumber)
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

    private var phoneNumberBinding: Binding<String> {
        Binding(get: { viewModel.newPhoneNumber }, set: viewModel.updateNewPhoneNumber)
    }

    private var verificationCodeBinding: Binding<String> {
        Binding(get: { viewModel.verificationCode }, set: viewModel.updateVerificationCode)
    }

    private var messagePresented: Binding<Bool> {
        Binding(get: { presentedMessage != nil }, set: { if !$0 { presentedMessage = nil } })
    }
}
