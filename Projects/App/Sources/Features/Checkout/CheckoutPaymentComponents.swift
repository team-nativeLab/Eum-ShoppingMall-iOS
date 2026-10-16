import SwiftUI

struct CheckoutPaymentMethodButton: View {
    let method: CheckoutPaymentMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(method.rawValue)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(isSelected ? EUMColor.text1SwiftUI : EUMColor.lineStrongSwiftUI, lineWidth: isSelected ? 1.5 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct CheckoutTaxInvoiceBusinessInfo: View {
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("사업자 정보")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Spacer()
                Button("변경", action: onEdit)
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityHint("세금계산서 발행용 사업자 정보를 변경합니다")
            }
            invoiceInfoRow(title: "사업자등록번호", value: "000-00-00000")
            invoiceInfoRow(title: "상호", value: "회사명")
            invoiceInfoRow(title: "대표자명", value: "홍길동")
            invoiceInfoRow(title: "수신 이메일", value: "example@email.com")
            Text("회원 정보에 등록된 사업자 정보로 발행합니다.")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private func invoiceInfoRow(title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
        }
        .font(EUMTypography.captionRegular)
        .accessibilityElement(children: .combine)
    }
}

struct CheckoutReceiptOptionButton: View {
    let option: CheckoutReceiptOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI, lineWidth: isSelected ? 1.5 : 1)
                        .frame(width: 18, height: 18)
                    if isSelected {
                        Circle()
                            .fill(EUMColor.text1SwiftUI)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(option.rawValue)
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .fixedSize()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
