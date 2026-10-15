import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    let onToggleSelection: () -> Void
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    let onOptionChange: () -> Void
    let onQuoteRequest: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggleSelection) {
                CartCheckbox(isSelected: item.isSelected, isDisabled: item.isSoldOut || item.isQuoteProduct)
                    .frame(width: 20, height: 80, alignment: .top)
            }
            .buttonStyle(.plain)
            .disabled(item.isSoldOut || item.isQuoteProduct)
            .accessibilityLabel(selectionAccessibilityLabel)

            ZStack {
                LinearGradient(
                    colors: [EUMColor.surfaceSwiftUI, Color(red: 232 / 255, green: 232 / 255, blue: 232 / 255)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image("ProductPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.medium))
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                if item.isQuoteProduct {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("견적 상품")
                            .font(EUMTypography.labelExtraSmall)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                            .padding(.horizontal, 6)
                            .frame(height: 20)
                            .overlay(RoundedRectangle(cornerRadius: EUMRadius.small).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                        productTitle
                    }
                } else {
                    HStack(spacing: 4) {
                        if item.isSoldOut {
                            Text("품절")
                                .font(EUMTypography.labelExtraSmall)
                                .foregroundStyle(EUMColor.inverseSwiftUI)
                                .padding(.horizontal, 6)
                                .frame(height: 20)
                                .background(EUMColor.text2SwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                        }
                        productTitle
                    }
                }

                Text("옵션: \(item.option)")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text3SwiftUI)

                Button("옵션 변경", action: onOptionChange)
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .underline()
                    .buttonStyle(.plain)

                if item.isQuoteProduct {
                    Button("견적 문의 →", action: onQuoteRequest)
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .underline()
                        .buttonStyle(.plain)
                }

                HStack {
                    Text(item.isQuoteProduct ? "가격 문의" : "₩00,000")
                        .font(.custom("NotoSansKR-Bold", size: 16))
                        .tracking(-0.08)
                        .foregroundStyle(item.isSoldOut ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                        .padding(.top, 8)

                    Spacer(minLength: 4)

                    QuantityStepper(quantity: item.quantity, isDisabled: item.isSoldOut, onChange: onQuantityChange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 28)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.vertical, 16)
        .frame(minHeight: 138)
        .overlay(alignment: .bottom) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1).padding(.horizontal, EUMSpacing.homeContentInset)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: onRemove) {
                Image("ProductOptionClose")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("상품 삭제")
            .padding(.trailing, 4)
            .padding(.top, 4)
        }
    }

    private var productTitle: some View {
        Text(item.title)
            .font(EUMTypography.labelMedium)
            .tracking(-0.07)
            .foregroundStyle(item.isSoldOut ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
            .lineLimit(1)
    }

    private var selectionAccessibilityLabel: String {
        if item.isQuoteProduct { return "견적 상품은 주문 선택에서 제외됩니다." }
        if item.isSoldOut { return "품절 상품" }
        return item.isSelected ? "선택됨" : "선택 안 됨"
    }
}

struct CartCheckbox: View {
    let isSelected: Bool
    let isDisabled: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: EUMRadius.small)
                .fill(isDisabled ? EUMColor.surfaceSwiftUI : isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
            if !isDisabled && isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(EUMColor.inverseSwiftUI)
            }
        }
        .frame(width: 20, height: 20)
        .overlay {
            RoundedRectangle(cornerRadius: EUMRadius.small)
                .stroke(isSelected || isDisabled ? Color.clear : EUMColor.lineStrongSwiftUI, lineWidth: 1)
        }
        .accessibilityHidden(true)
    }
}

private struct QuantityStepper: View {
    let quantity: Int
    let isDisabled: Bool
    let onChange: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button { onChange(-1) } label: {
                Image("ProductOptionMinus")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(quantity <= 1 || isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text1SwiftUI)
                    .frame(width: 36, height: 36)
            }
            .disabled(quantity <= 1 || isDisabled)
            .accessibilityLabel("수량 감소")

            Text("\(quantity)")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text1SwiftUI)
                .frame(width: 40, height: 36)
                .accessibilityLabel("수량 \(quantity)")

            Button { onChange(1) } label: {
                Image("ProductOptionPlus")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(isDisabled ? EUMColor.textDisabledSwiftUI : EUMColor.text1SwiftUI)
                    .frame(width: 36, height: 36)
            }
            .disabled(isDisabled)
            .accessibilityLabel("수량 증가")
        }
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
        .overlay {
            RoundedRectangle(cornerRadius: EUMRadius.button)
                .stroke(isDisabled ? EUMColor.lineSwiftUI : EUMColor.lineStrongSwiftUI, lineWidth: 1)
        }
        .fixedSize()
    }
}
