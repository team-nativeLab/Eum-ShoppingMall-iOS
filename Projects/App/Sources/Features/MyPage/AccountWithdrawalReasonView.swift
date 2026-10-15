import SwiftUI

struct AccountWithdrawalReasonView: View {
    @StateObject private var viewModel = AccountWithdrawalReasonViewModel()

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

    private var passwordGroup: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("비밀번호 확인")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack(spacing: 8) {
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("현재 비밀번호", text: $viewModel.password)
                    } else {
                        SecureField("현재 비밀번호", text: $viewModel.password)
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
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))
            Text("본인 확인을 위해 현재 비밀번호를 입력해 주세요.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "탈퇴하기", size: .large, action: onSubmit)
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
