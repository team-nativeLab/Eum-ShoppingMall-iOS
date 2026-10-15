import SwiftUI

struct OrderHistoryFilterChip: View {
    let status: OrderHistoryStatus
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(status.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                .padding(.horizontal, 14)
                .frame(height: 36)
                .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
                .overlay {
                    if !isSelected {
                        Capsule().stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct OrderHistoryOrderCard: View {
    let order: OrderHistoryItem
    let onDetail: () -> Void
    let onCancel: () -> Void
    let onTrack: () -> Void
    let onReorder: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            header
            product
            actions
        }
        .padding(16)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text(order.orderDate)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize()
            Text("주문번호 \(order.orderNumber)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Button(action: onDetail) {
                HStack(spacing: 2) {
                    Text("주문 상세")
                        .font(EUMTypography.captionMedium)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize()
            }
            .buttonStyle(.plain)
            .accessibilityLabel("주문 \(order.orderNumber) 상세")
        }
    }

    private var product: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("ProductPlaceholder")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                statusBadge
                Text(order.productName)
                    .font(EUMTypography.labelLarge)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                Text(order.priceAndQuantity)
                    .font(.custom("NotoSansKR-Bold", size: 16, relativeTo: .body))
                    .tracking(-0.32)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                if let depositDeadline = order.depositDeadline {
                    Text(depositDeadline)
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                } else if let extraProductCount = order.extraProductCount {
                    Text("제품명 외 \(extraProductCount)건")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statusBadge: some View {
        Text(order.status.rawValue)
            .font(EUMTypography.labelExtraSmall)
            .foregroundStyle(order.status == .delivered ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
            .padding(.horizontal, 6)
            .frame(height: 20)
            .background(order.status == .delivered ? EUMColor.text1SwiftUI : EUMColor.surfaceSwiftUI)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.small))
            .fixedSize()
    }

    @ViewBuilder
    private var actions: some View {
        if order.status == .awaitingPayment || order.status == .paymentComplete {
            EUMButton(title: "주문 취소", kind: .secondary, size: .small, action: onCancel)
        } else {
            HStack(spacing: 8) {
                EUMButton(title: "배송 조회", kind: .secondary, size: .small, action: onTrack)
                EUMButton(title: "다시 담기", kind: .secondary, size: .small, action: onReorder)
            }
        }
    }
}
