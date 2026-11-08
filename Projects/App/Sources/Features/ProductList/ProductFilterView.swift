import SwiftUI

struct ProductListFilter: Equatable {
    enum PriceRange: String, CaseIterable, Identifiable {
        case all = "전체"
        case under100Thousand = "10만 원 미만"
        case from100To500Thousand = "10만 원 이상 50만 원 미만"
        case over500Thousand = "50만 원 이상"

        var id: String { rawValue }

        func includes(_ amount: Int?) -> Bool {
            guard let amount, self != .all else { return true }
            switch self {
            case .all: return true
            case .under100Thousand: return amount < 100_000
            case .from100To500Thousand: return (100_000..<500_000).contains(amount)
            case .over500Thousand: return amount >= 500_000
            }
        }
    }

    enum Stock: String, CaseIterable, Identifiable {
        case all = "전체"
        case inStock = "재고 있음"
        case soldOut = "품절 상품"

        var id: String { rawValue }
    }

    var priceRange: PriceRange = .all
    var brand: String = "전체"
    var shippingType: ProductShippingType?
    var stock: Stock = .all

    var shippingTitle: String { shippingType?.rawValue ?? "전체" }

    func includes(_ product: HomeProduct) -> Bool {
        priceRange.includes(product.priceAmount) &&
            (brand == "전체" || product.brand == brand) &&
            (shippingType == nil || product.shippingType == shippingType) &&
            (stock == .all || (stock == .inStock ? !product.isSoldOut : product.isSoldOut))
    }
}

struct ProductFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var filter: ProductListFilter

    let brands: [String]
    let onApply: (ProductListFilter) -> Void

    init(
        filter: ProductListFilter,
        brands: [String],
        onApply: @escaping (ProductListFilter) -> Void
    ) {
        _filter = State(initialValue: filter)
        self.brands = brands
        self.onApply = onApply
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("원하는 조건을 선택한 뒤 적용해 주세요.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                    filterField(title: "가격대", value: filter.priceRange.rawValue) {
                        ForEach(ProductListFilter.PriceRange.allCases) { range in
                            Button(range.rawValue) { filter.priceRange = range }
                        }
                    }
                    filterField(title: "브랜드", value: filter.brand) {
                        ForEach(brands, id: \.self) { brand in
                            Button(brand) { filter.brand = brand }
                        }
                    }
                    filterField(title: "배송 유형", value: filter.shippingTitle) {
                        Button("전체") { filter.shippingType = nil }
                        ForEach(ProductShippingType.allCases) { type in
                            Button(type.rawValue) { filter.shippingType = type }
                        }
                    }
                    filterField(title: "재고", value: filter.stock.rawValue) {
                        ForEach(ProductListFilter.Stock.allCases) { stock in
                            Button(stock.rawValue) { filter.stock = stock }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSubtleSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomAction
        }
    }

    private var topBar: some View {
        ZStack {
            Text("필터")
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button { dismiss() } label: {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("상품 목록으로 돌아가기")
                Spacer()
                Button("초기화") { filter = ProductListFilter() }
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("product-filter-reset")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }

    private func filterField<MenuContent: View>(
        title: String,
        value: String,
        @ViewBuilder menu: () -> MenuContent
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Menu(content: menu) {
                HStack {
                    Text(value)
                        .font(EUMTypography.bodyMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    Spacer()
                    Image("AddressEditorChevronDown")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 13)
                .frame(height: 50)
                .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                .overlay {
                    RoundedRectangle(cornerRadius: EUMRadius.button)
                        .stroke(EUMColor.lineSwiftUI, lineWidth: 1)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(title) 선택")
        }
    }

    private var bottomAction: some View {
        EUMButton(title: "필터 적용", size: .large) {
            onApply(filter)
            dismiss()
        }
        .accessibilityIdentifier("product-filter-apply")
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(EUMColor.backgroundSwiftUI)
    }
}
