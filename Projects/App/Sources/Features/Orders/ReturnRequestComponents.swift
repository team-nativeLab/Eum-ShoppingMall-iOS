import PhotosUI
import SwiftUI

struct ReturnRequestSegmented: View {
    let selectedKind: ReturnRequestKind
    let onSelect: (ReturnRequestKind) -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(ReturnRequestKind.allCases) { kind in
                Button {
                    onSelect(kind)
                } label: {
                    Text(kind.rawValue)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                        .foregroundStyle(kind == selectedKind ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .background {
                            if kind == selectedKind {
                                RoundedRectangle(cornerRadius: EUMRadius.medium)
                                    .fill(EUMColor.backgroundSwiftUI)
                                    .shadow(color: EUMColor.text1SwiftUI.opacity(0.06), radius: 3, y: 1)
                            }
                        }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(kind == selectedKind ? .isSelected : [])
            }
        }
        .padding(4)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
    }
}

struct ReturnRequestProductRow: View {
    let product: ReturnRequestProduct
    let isSelected: Bool
    let quantity: Int
    let onToggle: () -> Void
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                ZStack {
                    RoundedRectangle(cornerRadius: EUMRadius.small)
                        .fill(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI)
                    RoundedRectangle(cornerRadius: EUMRadius.small)
                        .strokeBorder(
                            isSelected ? EUMColor.text1SwiftUI : EUMColor.lineControlSwiftUI,
                            lineWidth: isSelected ? 0 : 1.5
                        )
                    if isSelected {
                        Image("ReturnCheckboxCheck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                }
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isSelected ? "\(product.name) 선택됨" : "\(product.name) 선택")

            Image("ProductPlaceholder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .frame(width: 56, height: 56)
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
                Text(product.name)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .lineLimit(1)
                Text(product.option)
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ReturnRequestQuantityStepper(quantity: quantity, onDecrease: onDecrease, onIncrease: onIncrease)
        }
        .frame(minHeight: 56)
    }
}

struct ReturnRequestQuantityStepper: View {
    let quantity: Int
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onDecrease) {
                Image("ReturnStepperMinus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("수량 감소")

            Text("\(quantity)")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(width: 40, height: 36)
                .accessibilityLabel("수량 \(quantity)개")

            Button(action: onIncrease) {
                Image("ProductOptionPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("수량 증가")
        }
        .frame(width: 112, height: 36)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
    }
}

struct ReturnRequestReasonGrid: View {
    let selectedReason: ReturnRequestReason
    let onSelect: (ReturnRequestReason) -> Void

    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(ReturnRequestReason.allCases) { reason in
                let selected = reason == selectedReason
                Button { onSelect(reason) } label: {
                    Text(reason.rawValue)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                        .foregroundStyle(selected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                        .overlay {
                            RoundedRectangle(cornerRadius: EUMRadius.button)
                                .strokeBorder(selected ? EUMColor.text1SwiftUI : EUMColor.lineStrongSwiftUI, lineWidth: selected ? 1.5 : 1)
                        }
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selected ? .isSelected : [])
            }
        }
    }
}

struct ReturnRequestTextEditor: View {
    @Binding var text: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("상세 사유를 입력해 주세요.")
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.textDisabledSwiftUI)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
                TextEditor(text: $text)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .frame(minHeight: 96, maxHeight: 132)
                    .onChange(of: text) { _, value in
                        if value.count > 500 {
                            text = String(value.prefix(500))
                        }
                    }
            }
            .background(EUMColor.backgroundSwiftUI)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineControlSwiftUI, lineWidth: 1))

            HStack {
                Spacer()
                Text("\(text.count)/500")
                    .font(EUMTypography.captionRegular)
                    .foregroundStyle(EUMColor.text3SwiftUI)
                    .monospacedDigit()
            }
        }
    }
}

struct ReturnRequestPhotoTile: View {
    var body: some View {
        VStack(spacing: 4) {
            Image("ReturnPhotoAdd")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text("0/0")
                .font(EUMTypography.captionRegular)
                .foregroundStyle(EUMColor.text3SwiftUI)
        }
        .frame(width: 72, height: 72)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
        .overlay {
            RoundedRectangle(cornerRadius: EUMRadius.button)
                        .strokeBorder(EUMColor.lineControlSwiftUI, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("사진 추가")
    }
}

struct ReturnRequestPhotoThumbnail: View {
    let photo: ReturnRequestPhoto
    let onRemove: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("ProductPlaceholder")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            LinearGradient(
                                colors: [EUMColor.imagePlaceholderSecondaryTopSwiftUI, EUMColor.imagePlaceholderSecondaryBottomSwiftUI],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: EUMRadius.button))

            Button(action: onRemove) {
                Image("ReturnPhotoRemove")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .frame(width: 20, height: 20)
                    .background(EUMColor.text1SwiftUI, in: RoundedRectangle(cornerRadius: 10))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .offset(x: 4, y: -4)
            .accessibilityLabel("사진 삭제")
        }
        .frame(width: 72, height: 72)
    }
}

struct ReturnPickupOption: View {
    let method: ReturnPickupMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isSelected {
                    Image("ReturnRadioSelected")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Circle()
                        .fill(EUMColor.backgroundSwiftUI)
                        .frame(width: 20, height: 20)
                        .overlay(Circle().stroke(EUMColor.lineControlSwiftUI, lineWidth: 1.5))
                }
                Text(method.rawValue)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct ReturnRefundAmountCard: View {
    var body: some View {
        VStack(spacing: 12) {
            summaryRow(title: "상품 금액", value: "₩00,000")
            summaryRow(title: "반품 배송비", value: "-₩0")
            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
            HStack {
                Text("환불 예정 금액")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                Spacer()
                Text("₩00,000")
                    .font(.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                    .tracking(-0.36)
            }
            .foregroundStyle(EUMColor.text1SwiftUI)
            summaryRow(title: "환불 수단", value: "결제 수단과 동일", regularValue: true)
        }
        .padding(16)
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
    }

    private func summaryRow(title: String, value: String, regularValue: Bool = false) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Spacer()
            Text(value)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .font(regularValue ? EUMTypography.bodySmall : EUMTypography.labelMedium)
        .tracking(-0.07)
    }
}

struct ReturnRequestNotice: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("DeliveryInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
                .accessibilityHidden(true)
            Text(message)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }
}
