import SwiftUI

struct OrderDetailCard<Content: View>: View {
    var title: String?
    @ViewBuilder let content: Content

    init(title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }
}

struct OrderDetailProductSection: View {
    let products: [OrderDetailProduct]

    var body: some View {
        OrderDetailCard(title: "주문 상품") {
            VStack(spacing: 12) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    productRow(product)
                    if index < products.count - 1 {
                        Rectangle()
                            .fill(EUMColor.lineSwiftUI)
                            .frame(height: 1)
                    }
                }
            }
        }
    }

    private func productRow(_ product: OrderDetailProduct) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image("ProductPlaceholder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 64, height: 64)
                .background {
                    LinearGradient(
                        colors: [EUMColor.imagePlaceholderTopSwiftUI, EUMColor.imagePlaceholderBottomSwiftUI],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.status.rawValue)
                    .font(EUMTypography.labelExtraSmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .padding(.horizontal, 6)
                    .frame(height: 20)
                    .background(EUMColor.surfaceSecondarySwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                    .fixedSize()
                Text(product.name)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                Text(product.option)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                Text(product.priceAndQuantity)
                    .font(.custom("NotoSansKR-Bold", size: 16, relativeTo: .body))
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct OrderDetailKeyValueRows: View {
    let rows: [OrderDetailRow]
    let labelWidth: CGFloat

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows) { row in
                HStack(alignment: .top, spacing: 12) {
                    Text(row.title)
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .frame(width: labelWidth, alignment: .leading)
                    Text(row.value)
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct OrderDetailSummaryRow: View {
    let title: String
    let value: String
    var isMedium = false

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(isMedium ? EUMTypography.labelMedium : EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(isMedium ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(isMedium ? EUMTypography.labelMedium : EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
    }
}

struct OrderDetailMenuRow: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.custom("NotoSansKR-Regular", size: 16, relativeTo: .body))
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image("OrderDetailChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
