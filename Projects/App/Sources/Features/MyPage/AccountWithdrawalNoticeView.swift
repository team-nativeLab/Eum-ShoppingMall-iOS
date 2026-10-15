import SwiftUI

struct AccountWithdrawalNoticeView: View {
    @StateObject private var viewModel = AccountWithdrawalNoticeViewModel()

    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    introduction
                    benefitSummary
                    noticeList
                    agreementControl
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
                .accessibilityLabel("내 정보 관리로 돌아가기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("탈퇴하기 전에 꼭 확인해 주세요")
                .font(EUMTypography.heading2)
                .tracking(-0.44)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
            Text("\(viewModel.memberName)님, 탈퇴하면 아래 혜택과 정보가 모두 사라집니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var benefitSummary: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 0) {
                benefitCell(icon: "CouponTicket", title: "보유 쿠폰", value: "\(viewModel.couponCount)장")
                Rectangle()
                    .fill(EUMColor.lineSwiftUI)
                    .frame(width: 1)
                benefitCell(icon: "CouponCoins", title: "적립금", value: "\(viewModel.pointsBalance)원")
            }
            Text("탈퇴 즉시 소멸되며, 재가입해도 복구되지 않습니다.")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func benefitCell(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text(title)
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Text(value)
                .font(.custom("NotoSansKR-Bold", size: 24))
                .tracking(-0.36)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .frame(maxWidth: .infinity)
    }

    private var noticeList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("탈퇴 유의사항")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            ForEach(viewModel.notices, id: \.self) { notice in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(EUMColor.text3SwiftUI)
                        .frame(width: 4, height: 4)
                        .padding(.top, 8)
                    Text(notice)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var agreementControl: some View {
        Button {
            viewModel.hasAgreedToWithdrawal.toggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: viewModel.hasAgreedToWithdrawal ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(viewModel.hasAgreedToWithdrawal ? EUMColor.text1SwiftUI : Color(uiColor: .systemGray))
                    .frame(width: 20, height: 20)
                Text("위 내용을 모두 확인했으며, 탈퇴에 동의합니다.")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .accessibilityLabel("위 내용을 모두 확인했으며, 탈퇴에 동의합니다")
        .accessibilityAddTraits(viewModel.hasAgreedToWithdrawal ? .isSelected : [])
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "다음", size: .large, action: onContinue)
                .disabled(!viewModel.hasAgreedToWithdrawal)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
