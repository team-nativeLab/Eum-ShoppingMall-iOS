import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var presentedMessage: String?
    @State private var isShowingTermsModal = false
    @State private var isShowingPrivacyConsent = false
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                formContent
            }
            .scrollIndicators(.hidden)
            bottomAction
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
        .overlay {
            if isShowingTermsModal {
                TermsAgreementModalView(
                    onClose: { isShowingTermsModal = false },
                    onAgree: {
                        viewModel.agreeToTerms()
                        isShowingTermsModal = false
                    }
                )
            }
            if isShowingPrivacyConsent {
                PrivacyConsentView(
                    onClose: { isShowingPrivacyConsent = false },
                    onAgree: {
                        viewModel.agreeToPrivacy()
                        isShowingPrivacyConsent = false
                    }
                )
            }
        }
    }

    private var topBar: some View {
        ZStack {
            Text("회원가입")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("로그인으로 돌아가기")
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var formContent: some View {
        VStack(spacing: 20) {
            memberTypePicker
            emailRow
            passwordField
            passwordConfirmationField
            nameField
            phoneVerification
            if viewModel.isBusinessMember {
                BusinessSignUpInformationView(viewModel: viewModel) { presentedMessage = $0 }
            }
            agreements
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }

    private var memberTypePicker: some View {
        HStack(spacing: 4) {
            memberTypeButton("개인 회원", isSelected: !viewModel.isBusinessMember)
            memberTypeButton("사업자 회원", isSelected: viewModel.isBusinessMember)
        }
        .padding(4)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private func memberTypeButton(_ title: String, isSelected: Bool) -> some View {
        Button {
            viewModel.selectMemberType(isBusiness: title == "사업자 회원")
        } label: {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: EUMRadius.medium)
                            .fill(EUMColor.backgroundSwiftUI)
                            .shadow(color: EUMColor.text1SwiftUI.opacity(0.06), radius: 3, y: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var emailRow: some View {
        HStack(alignment: .bottom, spacing: 8) {
            EUMTextField(title: "이메일 *", placeholder: "example@email.com", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            EUMButton(title: "중복 확인", kind: .secondary, size: .medium) {
                let canCheck = viewModel.markEmailChecked()
                presentedMessage = canCheck
                    ? "이메일 중복 확인은 서버 연동 후 이용할 수 있어요."
                    : "올바른 이메일 주소를 입력해 주세요."
            }
            .frame(width: 89)
            .padding(.top, 28)
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            EUMTextField(
                title: "비밀번호 *",
                placeholder: "비밀번호를 입력해 주세요",
                text: $viewModel.password,
                isSecure: true
            )
            Text("영문·숫자 조합 8자 이상")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var passwordConfirmationField: some View {
        EUMTextField(
            title: "비밀번호 확인 *",
            placeholder: "비밀번호를 한 번 더 입력해 주세요",
            text: $viewModel.passwordConfirmation,
            isSecure: true
        )
    }

    private var nameField: some View {
        EUMTextField(title: "이름 *", placeholder: "이름을 입력해 주세요", text: $viewModel.name)
            .textContentType(.name)
    }

    private var phoneVerification: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 8) {
                EUMTextField(title: "휴대폰 번호 *", placeholder: "010-0000-0000", text: $viewModel.phoneNumber)
                    .keyboardType(.phonePad)
                EUMButton(title: "재전송", kind: .secondary, size: .medium) {
                    presentedMessage = "휴대폰 인증은 서버 연동 후 이용할 수 있어요."
                }
                .frame(width: 73)
            }
            HStack(spacing: 8) {
                TextField("인증번호 6자리", text: $viewModel.verificationCode)
                    .font(EUMTypography.bodyMedium)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.text1SwiftUI, lineWidth: 1.5))
                    .accessibilityLabel("인증번호 6자리")
                EUMButton(title: "확인", kind: .secondary, size: .medium) {
                    let verified = viewModel.verifyPhoneCode()
                    presentedMessage = verified ? "목업 인증번호가 확인됐어요." : "인증번호를 다시 확인해 주세요."
                }
                .frame(width: 60)
                .disabled(viewModel.verificationCode.count != 6)
            }
            Text("남은 시간 02:59")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var agreements: some View {
        VStack(spacing: 12) {
            agreementRow("전체 동의", isOn: allAgreements, isAll: true, action: viewModel.toggleAllAgreements)
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
            agreementRow(
                "[필수] 이용약관 동의",
                isOn: viewModel.agreedToTerms,
                action: viewModel.toggleTerms,
                details: true,
                onDetailsTap: { isShowingTermsModal = true }
            )
            agreementRow(
                "[필수] 개인정보 수집·이용 동의",
                isOn: viewModel.agreedToPrivacy,
                action: viewModel.togglePrivacy,
                details: true,
                onDetailsTap: { isShowingPrivacyConsent = true }
            )
            agreementRow("[선택] 마케팅 정보 수신 동의", isOn: viewModel.agreedToMarketing, action: viewModel.toggleMarketing, details: true)
        }
        .padding(16)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var allAgreements: Bool {
        viewModel.agreedToTerms && viewModel.agreedToPrivacy && viewModel.agreedToMarketing
    }

    private func agreementRow(
        _ title: String,
        isOn: Bool,
        isAll: Bool = false,
        action: @escaping () -> Void,
        details: Bool = false,
        onDetailsTap: (() -> Void)? = nil
    ) -> some View {
        HStack(spacing: 10) {
            Button(action: action) {
                agreementCheckbox(isOn: isOn)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(title)
            .accessibilityValue(isOn ? "동의" : "동의 안 함")

            Text(title)
                .font(isAll ? EUMTypography.labelLarge : EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
            if details {
                Button("보기") {
                    if let onDetailsTap {
                        onDetailsTap()
                    } else {
                        presentedMessage = "약관 내용은 이용약관 화면 연결 후 확인할 수 있어요."
                    }
                }
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .underline()
            }
        }
        .frame(minHeight: isAll ? 24 : 20)
        .contentShape(Rectangle())
    }

    private func agreementCheckbox(isOn: Bool) -> some View {
        RoundedRectangle(cornerRadius: EUMRadius.small)
            .fill(isOn ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
            .frame(width: 20, height: 20)
            .overlay {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .stroke(isOn ? EUMColor.text1SwiftUI : EUMColor.lineControlSwiftUI, lineWidth: 1.5)
            }
            .overlay {
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                }
            }
            .accessibilityHidden(true)
    }

    private var bottomAction: some View {
        VStack(spacing: 12) {
            Text("필수 항목 입력과 약관 동의를 마치면 가입할 수 있습니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            EUMButton(title: "가입하기", size: .large) {
                presentedMessage = "회원가입은 서버 연동 후 이용할 수 있어요."
            }
            .disabled(!viewModel.canSubmit)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }
}

struct SignUpViewPreview: PreviewProvider {
    static var previews: some View {
        SignUpView(onBack: {})
    }
}
