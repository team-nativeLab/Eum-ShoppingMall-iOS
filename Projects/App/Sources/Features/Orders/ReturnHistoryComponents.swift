import SwiftUI

struct ReturnHistoryFilterChip: View {
    let filter: ReturnHistoryFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(filter.rawValue)
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

struct ReturnHistoryCard: View {
    let item: ReturnHistoryItem
    let onDetail: () -> Void
    let onWithdraw: () -> Void
    let onRejectionReason: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            product
            if item.kind == .returnRequest {
                HStack {
                    Text("환불 예정 금액")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                    Spacer()
                    Text(item.refundAmount)
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
            }
            if item.status == .requested {
                EUMButton(title: "신청 철회", kind: .ghost, size: .small, action: onWithdraw)
            } else if item.status == .rejected {
                EUMButton(title: "반려 사유 보기", kind: .secondary, size: .small, action: onRejectionReason)
            }
        }
        .padding(16)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text(item.orderDate)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize()
            Text("\(item.kind.rawValue) · 주문번호 \(item.orderNumber)")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Button(action: onDetail) {
                HStack(spacing: 2) {
                    Text("신청 상세")
                        .font(EUMTypography.captionMedium)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
                .fixedSize()
            }
            .buttonStyle(.plain)
        }
    }

    private var badgeForeground: Color {
        switch item.status {
        case .requested, .rejected: EUMColor.dangerSwiftUI
        case .exchangeComplete: Color(red: 30 / 255, green: 122 / 255, blue: 60 / 255)
        case .collecting: EUMColor.text2SwiftUI
        }
    }

    private var badgeBackground: Color {
        switch item.status {
        case .requested, .rejected: Color(red: 253 / 255, green: 236 / 255, blue: 234 / 255)
        case .exchangeComplete: Color(red: 232 / 255, green: 243 / 255, blue: 236 / 255)
        case .collecting: EUMColor.backgroundSwiftUI
        }
    }

    private var product: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                LinearGradient(
                    colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image("RequestProduct")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.status.rawValue)
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(badgeForeground)
                    .padding(.horizontal, 6)
                    .frame(height: 20)
                    .background(badgeBackground)
                    .overlay {
                        if item.status == .collecting {
                            RoundedRectangle(cornerRadius: EUMRadius.small).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: EUMRadius.small))
                    .fixedSize()
                Text(item.productName)
                    .font(EUMTypography.bodyMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                Text(item.priceAndQuantity)
                    .font(.custom("NotoSansKR-Bold", size: 16, relativeTo: .body))
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
