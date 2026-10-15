import SwiftUI

@MainActor
final class ProductOptionsSheetViewModel: ObservableObject {
    let availableSizes = ["S", "M", "L", "XL"]
    @Published private(set) var quantities: [String: Int] = ["L": 1, "XL": 1]

    var selectedSizes: [String] {
        availableSizes.filter { quantities[$0] != nil }
    }

    var totalCount: Int {
        quantities.values.reduce(0, +)
    }

    func add(size: String) {
        guard quantities[size] == nil else { return }
        quantities[size] = 1
    }

    func remove(size: String) {
        quantities[size] = nil
    }

    func increment(size: String) {
        quantities[size, default: 1] += 1
    }

    func decrement(size: String) {
        guard let quantity = quantities[size], quantity > 1 else { return }
        quantities[size] = quantity - 1
    }

    func quantity(for size: String) -> Int {
        quantities[size, default: 1]
    }
}

struct ProductOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductOptionsSheetViewModel()

    let onAddToCart: () -> Void
    let onBuyNow: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(spacing: 20) {
                optionGroup
                totalGroup
            }
            .padding(20)
            .frame(maxHeight: .infinity, alignment: .top)

            bottomActions
        }
        .background(EUMColor.backgroundSwiftUI)
        .accessibilityIdentifier("productOptionsSheet")
    }

    private var header: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(EUMColor.lineStrongSwiftUI)
                .frame(width: 36, height: 4)
                .padding(.top, 8)

            HStack {
                Text("옵션 선택")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("옵션 창 닫기")
            }
            .padding(.leading, 20)
            .padding(.trailing, 8)
            .frame(height: 56)
        }
        .background(EUMColor.backgroundSwiftUI)
        .shadow(color: EUMColor.text1SwiftUI.opacity(0.04), radius: 8, x: 0, y: 4)
    }

    private var optionGroup: some View {
        VStack(alignment: .leading, spacing: 16) {
            sizePicker

            VStack(spacing: 8) {
                ForEach(viewModel.selectedSizes, id: \.self) { size in
                    optionCard(size: size)
                }
            }
        }
    }

    private var sizePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("사이즈")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)

            Menu {
                ForEach(viewModel.availableSizes, id: \.self) { size in
                    Button("사이즈 \(size)") {
                        viewModel.add(size: size)
                    }
                    .disabled(viewModel.selectedSizes.contains(size))
                }
            } label: {
                HStack(spacing: 8) {
                    Text("사이즈를 선택해 주세요")
                        .font(EUMTypography.bodyMedium)
                        .tracking(-0.075)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image("ProductOptionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(EUMColor.backgroundSwiftUI)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.text3SwiftUI, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .accessibilityLabel("사이즈 선택")
        }
    }

    private func optionCard(size: String) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("사이즈 \(size)")
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Spacer()

                Button {
                    viewModel.remove(size: size)
                } label: {
                    Image("ProductOptionClose")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("사이즈 \(size) 삭제")
            }

            HStack {
                quantityStepper(size: size)
                Spacer()
                Text("₩00,000")
                    .font(Font.custom("NotoSansKR-Bold", size: 16, relativeTo: .body))
                    .tracking(-0.08)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
        }
        .padding(16)
        .frame(height: 108)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func quantityStepper(size: String) -> some View {
        HStack(spacing: 0) {
            Button {
                viewModel.decrement(size: size)
            } label: {
                Image("ProductOptionMinus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .disabled(viewModel.quantity(for: size) <= 1)
            .accessibilityLabel("사이즈 \(size) 수량 감소")

            Text("\(viewModel.quantity(for: size))")
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(width: 40, height: 40)
                .accessibilityLabel("수량 \(viewModel.quantity(for: size))")

            Button {
                viewModel.increment(size: size)
            } label: {
                Image("ProductOptionPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("사이즈 \(size) 수량 증가")
        }
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
        .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 8))
    }

    private var totalGroup: some View {
        VStack(spacing: 16) {
            EUMColor.lineSwiftUI.frame(height: 1)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("총 금액")
                        .font(EUMTypography.bodySmall)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                    Text("총 \(viewModel.totalCount)개")
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }

                Spacer()

                Text("₩00,000")
                    .font(Font.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                    .tracking(-0.36)
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
        }
        .padding(.top, 16)
        .frame(height: 59, alignment: .top)
    }

    private var bottomActions: some View {
        HStack(spacing: 8) {
            EUMButton(title: "장바구니 담기", size: .large) {
                onAddToCart()
                dismiss()
            }

            EUMButton(title: "바로 구매", kind: .secondary, size: .large) {
                onBuyNow()
                dismiss()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .overlay(alignment: .top) { EUMColor.lineSwiftUI.frame(height: 1) }
        .background(EUMColor.backgroundSwiftUI)
    }
}
