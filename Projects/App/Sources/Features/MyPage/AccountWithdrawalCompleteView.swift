import SwiftUI

struct AccountWithdrawalCompleteView: View {
    private let viewModel: AccountWithdrawalCompleteViewModel

    let onHome: () -> Void

    init(viewModel: AccountWithdrawalCompleteViewModel = AccountWithdrawalCompleteViewModel(), onHome: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onHome = onHome
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 32) {
                    completionHeader
                    completionSummary
                    retentionNotice
                }
                .padding(.horizontal, 20)
                .padding(.top, 48)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            homeAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text("회원 탈퇴")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onHome) {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("닫기")
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var completionHeader: some View {
        VStack(spacing: 24) {
            Image("WithdrawalComplete")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 64, height: 64)
                .background(EUMColor.text1SwiftUI, in: Circle())
                .accessibilityHidden(true)
            VStack(spacing: 8) {
                Text(viewModel.title)
                    .font(EUMTypography.heading2)
                    .tracking(-0.44)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                Text(viewModel.description)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var completionSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            summaryRow(title: "탈퇴 일시", value: viewModel.completion.withdrawalDate)
            summaryRow(title: "재가입 가능일", value: viewModel.completion.rejoinAvailableDate)
        }
        .font(EUMTypography.bodySmall)
        .tracking(-0.07)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 84, alignment: .leading)
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var retentionNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("ProductDetailInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
            Text(viewModel.retentionNotice)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: 12))
    }

    private var homeAction: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            EUMButton(title: "홈으로", size: .large, action: onHome)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
    }
}
