import SwiftUI

struct ProfileEditView: View {
    @StateObject private var viewModel = ProfileEditViewModel()
    @State private var presentedMessage: String?
    @State private var isPasswordChangePresented = false

    let onBack: () -> Void
    let onAction: (String) -> Void
    var onWithdrawTap: () -> Void = {}

    var body: some View {
        Group {
            if isPasswordChangePresented {
                PasswordChangeView(onBack: { isPasswordChangePresented = false })
            } else {
                profileContent
            }
        }
    }

    private var profileContent: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    basicInformation
                    passwordChange
                    businessInformation
                    marketingAgreements
                    withdrawLink
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            saveAction
        }
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var topBar: some View {
        ZStack {
            Text("내 정보 수정")
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
                .accessibilityLabel("내 정보 관리로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var basicInformation: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("기본 정보")
            VStack(spacing: 16) {
                ProfileEditField(title: "이메일", text: .constant(viewModel.email), isDisabled: true)
                ProfileEditField(title: "이름", text: $viewModel.name)
                HStack(alignment: .bottom, spacing: 8) {
                    ProfileEditField(title: "휴대폰 번호", text: $viewModel.phoneNumber)
                    EUMButton(title: "변경", kind: .secondary, size: .medium) {
                        onAction("휴대폰 번호 변경 화면은 인증 서비스 연동 후 이용할 수 있어요.")
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
        }
    }

    private var passwordChange: some View {
        Button {
            isPasswordChangePresented = true
        } label: {
            HStack(spacing: 12) {
                Image("ProfileEditPassword")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("비밀번호 변경")
                    .font(Font.custom("NotoSansKR-Regular", size: 16, relativeTo: .body))
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                Image("ProfileEditChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var businessInformation: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                sectionTitle("사업자 정보")
                Text("사업자 회원에게만 표시됩니다.")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
            VStack(spacing: 16) {
                ProfileEditField(title: "회사명", text: $viewModel.companyName)
                ProfileEditField(
                    title: "사업자등록번호",
                    text: .constant(viewModel.businessNumber),
                    isDisabled: true,
                    helper: viewModel.businessNumberNotice
                )
                ProfileEditField(title: "담당 부서", placeholder: "부서명을 입력해 주세요", text: $viewModel.department)
            }
        }
    }

    private var marketingAgreements: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("수신 동의")
            VStack(alignment: .leading, spacing: 8) {
                agreementRow("SMS 수신 동의", isSelected: $viewModel.agreesToSMS)
                agreementRow("이메일 수신 동의", isSelected: $viewModel.agreesToEmail)
                Text(viewModel.marketingNotice)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .padding(.top, 2)
            }
        }
    }

    private var withdrawLink: some View {
        Button {
            onWithdrawTap()
        } label: {
            Text("회원 탈퇴")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .underline()
                .frame(minHeight: 24, alignment: .leading)
        }
        .buttonStyle(.plain)
    }

    private var saveAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "저장", size: .large) {
                presentedMessage = viewModel.save()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func agreementRow(_ title: String, isSelected: Binding<Bool>) -> some View {
        Button {
            isSelected.wrappedValue.toggle()
        } label: {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: EUMRadius.small)
                    .fill(isSelected.wrappedValue ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                    .frame(width: 20, height: 20)
                    .overlay {
                        if isSelected.wrappedValue {
                            Image("ProfileEditCheck")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                        } else {
                            RoundedRectangle(cornerRadius: EUMRadius.small)
                                .stroke(EUMColor.lineControlSwiftUI, lineWidth: 1.5)
                        }
                    }
                Text(title)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer(minLength: 0)
            }
            .frame(minHeight: 24)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected.wrappedValue ? .isSelected : [])
    }

    private var messagePresented: Binding<Bool> {
        Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )
    }
}

private struct ProfileEditField: View {
    let title: String
    var placeholder = ""
    @Binding var text: String
    var isDisabled = false
    var helper: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
            TextField(placeholder, text: $text)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text1SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(isDisabled ? EUMColor.surfaceSwiftUI : EUMColor.backgroundSwiftUI)
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(isDisabled ? EUMColor.lineSwiftUI : EUMColor.lineControlSwiftUI, lineWidth: 1)
                }
                .disabled(isDisabled)
                .accessibilityLabel(title)
            if let helper {
                Text(helper)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
        }
    }
}

struct ProfileEditViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileEditView(onBack: {}, onAction: { _ in })
    }
}
