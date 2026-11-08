import SwiftUI

struct AccountWithdrawalReasonView: View {
    @StateObject private var viewModel = AccountWithdrawalReasonViewModel()
    @State private var isShowingConfirmation = false

    let onBack: () -> Void
    let onSubmit: () -> Void

    private let reasonColumns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    introduction
                    reasonGroup
                    passwordGroup
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
        .overlay {
            if isShowingConfirmation {
                confirmationOverlay
            }
        }
    }

    private var topBar: some View {
        ZStack {
            Text("회원 탈퇴")
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
                .accessibilityLabel("탈퇴 안내로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("탈퇴하시는 이유를 알려 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            Text("더 나은 서비스를 만드는 데 참고하겠습니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
        }
    }

    private var reasonGroup: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("탈퇴 사유")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            LazyVGrid(columns: reasonColumns, spacing: 8) {
                ForEach(viewModel.reasonOptions) { option in
                    reasonOption(option)
                }
            }
            if viewModel.isOtherSelected {
                reasonDetailField
            }
        }
    }

    private func reasonOption(_ option: WithdrawalReasonOption) -> some View {
        let isSelected = viewModel.selectedReasonID == option.id
        return Button {
            viewModel.selectedReasonID = option.id
        } label: {
            Text(option.title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? EUMColor.text1SwiftUI : EUMColor.lineStrongSwiftUI, lineWidth: isSelected ? 1.5 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.id == "other" ? "기타" : "탈퇴 사유 \(option.id.suffix(1))")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var reasonDetailField: some View {
        VStack(spacing: 8) {
            TextField("자세한 사유를 입력해 주세요.", text: reasonDetailBinding, axis: .vertical)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(4...6)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, minHeight: 96, alignment: .topLeading)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
                .accessibilityLabel("자세한 탈퇴 사유")
            HStack(alignment: .top, spacing: 8) {
                Text("자세한 사유를 입력해 주세요.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(viewModel.reasonDetailCount)/\(viewModel.reasonDetailLimit)")
                    .fixedSize()
            }
            .font(EUMTypography.captionRegular)
            .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var reasonDetailBinding: Binding<String> {
        Binding(get: { viewModel.reasonDetail }, set: viewModel.updateReasonDetail)
    }

    private var passwordBinding: Binding<String> {
        Binding(get: { viewModel.password }, set: viewModel.updatePassword)
    }

    private var passwordGroup: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("비밀번호 확인")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack(spacing: 8) {
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("현재 비밀번호", text: passwordBinding)
                    } else {
                        SecureField("현재 비밀번호", text: passwordBinding)
                    }
                }
                .font(EUMTypography.bodyMedium)
                .tracking(2)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .textContentType(.password)
                .accessibilityLabel("현재 비밀번호")
                Button {
                    viewModel.isPasswordVisible.toggle()
                } label: {
                    Group {
                        if viewModel.isPasswordVisible {
                            Image(systemName: "eye")
                                .font(.system(size: 20))
                                .foregroundStyle(EUMColor.text2SwiftUI)
                        } else {
                            Image("WithdrawalPasswordVisibility")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.isPasswordVisible ? "비밀번호 숨기기" : "비밀번호 표시")
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.isPasswordInvalid ? EUMColor.dangerSwiftUI : EUMColor.lineControlSwiftUI,
                            lineWidth: viewModel.isPasswordInvalid ? 1.5 : 1)
            }
            if viewModel.isPasswordInvalid {
                HStack(alignment: .center, spacing: 4) {
                    Image("WithdrawalPasswordError")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .accessibilityHidden(true)
                    Text("비밀번호가 일치하지 않습니다. 다시 입력해 주세요.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
            } else {
                Text("본인 확인을 위해 현재 비밀번호를 입력해 주세요.")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "탈퇴하기", size: .large) {
                if viewModel.validatePassword() {
                    isShowingConfirmation = true
                }
            }
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }

    private var confirmationOverlay: some View {
        ZStack {
            Color.black.opacity(0.48)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image("WithdrawalAlert")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("정말 탈퇴하시겠습니까?")
                            .font(EUMTypography.heading3)
                            .tracking(-0.27)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text("탈퇴하면 계정을 복구할 수 없습니다.\n아래 혜택은 즉시 소멸됩니다.")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                    impactSummary
                }
                HStack(spacing: 8) {
                    EUMButton(title: "취소", kind: .secondary, size: .medium) {
                        isShowingConfirmation = false
                    }
                    EUMButton(title: "탈퇴하기", kind: .danger, size: .medium) {
                        isShowingConfirmation = false
                        onSubmit()
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 350)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: EUMColor.text1SwiftUI.opacity(0.16), radius: 16, x: 0, y: 12)
            .padding(.horizontal, 20)
            .accessibilityAddTraits(.isModal)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .zIndex(2)
    }

    private var impactSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image("CouponTicket")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text("쿠폰 0장 소멸")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            HStack(spacing: 8) {
                Image("CouponCoins")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text("적립금 0원 소멸")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
    }
}
