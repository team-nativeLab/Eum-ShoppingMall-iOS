import SwiftUI

struct ReturnRequestDetailView: View {
    let item: ReturnHistoryItem
    let onBack: () -> Void
    let onWithdraw: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "신청 상세",
                backAccessibilityLabel: "신청 내역으로 돌아가기",
                backAccessibilityIdentifier: "return-request-detail-back",
                onBack: onBack
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    statusSection
                    section(title: "신청 상품") {
                        HStack(alignment: .top, spacing: 12) {
                            productImage
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.productName)
                                    .font(EUMTypography.bodyMedium)
                                    .foregroundStyle(EUMColor.text1SwiftUI)
                                Text(item.priceAndQuantity)
                                    .font(EUMTypography.labelMedium)
                                    .foregroundStyle(EUMColor.text1SwiftUI)
                            }
                        }
                    }
                    section(title: "신청 정보") {
                        detailRow("신청 유형", value: item.kind.rawValue)
                        detailRow("신청일", value: item.orderDate)
                        detailRow("주문번호", value: item.orderNumber)
                        detailRow("신청 상태", value: item.status.rawValue)
                    }
                    if item.kind != .exchange {
                        section(title: "환불 정보") {
                            detailRow("환불 예정 금액", value: item.refundAmount)
                            Text("환불 금액과 처리 상태는 실제 주문 서비스 연결 후 확인할 수 있습니다.")
                                .font(EUMTypography.captionRegular)
                                .foregroundStyle(EUMColor.text3SwiftUI)
                        }
                    }
                    if let rejectionReason = item.rejectionReason {
                        section(title: "반려 사유") {
                            Text(rejectionReason)
                                .font(EUMTypography.bodySmall)
                                .foregroundStyle(EUMColor.text2SwiftUI)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    if item.status == .requested {
                        EUMButton(title: "신청 철회", kind: .secondary, action: onWithdraw)
                    }
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.status.rawValue)
                .font(EUMTypography.heading2)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text("신청 정보는 목업 데이터이며 실제 주문 처리 결과가 아닙니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private func detailRow(_ title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Spacer(minLength: 8)
            Text(value)
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .multilineTextAlignment(.trailing)
        }
    }

    private var productImage: some View {
        ZStack {
            LinearGradient(
                colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                startPoint: .top,
                endPoint: .bottom
            )
            Image("ProductPlaceholder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .accessibilityHidden(true)
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
    }
}

struct ReturnWithdrawalConfirmationView: View {
    let item: ReturnHistoryItem
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "신청 철회",
                backAccessibilityLabel: "신청 내역으로 돌아가기",
                backAccessibilityIdentifier: "return-withdrawal-cancel",
                onBack: onCancel
            ) {
                Color.clear.frame(width: 44, height: 44).accessibilityHidden(true)
            }
            Spacer(minLength: 0)
            VStack(spacing: 16) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 40, weight: .regular))
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .accessibilityHidden(true)
                Text("신청을 철회할까요?")
                    .font(EUMTypography.heading3)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Text("\(item.kind.rawValue) 신청 · \(item.productName)")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .multilineTextAlignment(.center)
                Text("현재 화면은 샘플 상태입니다. 확인해도 실제 신청은 철회되지 않습니다.")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            Spacer(minLength: 0)
            VStack(spacing: 8) {
                EUMButton(title: "철회 요청", kind: .danger, action: onConfirm)
                EUMButton(title: "취소", kind: .secondary, action: onCancel)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }
}
