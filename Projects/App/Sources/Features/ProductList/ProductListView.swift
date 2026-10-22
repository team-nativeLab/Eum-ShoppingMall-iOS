import SwiftUI

@MainActor
final class ProductListViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case recommended = "추천순"
        case priceAscending = "낮은 가격순"
        case priceDescending = "높은 가격순"

        var id: String { rawValue }
    }

    @Published var selectedCategory = "전체"
    @Published var sortOption: SortOption = .recommended
    @Published private(set) var filter = ProductListFilter()

    let products: [HomeProduct]

    init(products: [HomeProduct]) {
        self.products = products
    }

    var sortedProducts: [HomeProduct] {
        let filteredProducts = products.filter(filter.includes)
        switch sortOption {
        case .recommended:
            return filteredProducts
        case .priceAscending:
            return filteredProducts.sorted { ($0.priceAmount ?? 0) < ($1.priceAmount ?? 0) }
        case .priceDescending:
            return filteredProducts.sorted { ($0.priceAmount ?? 0) > ($1.priceAmount ?? 0) }
        }
    }

    var availableBrands: [String] {
        ["전체"] + Array(Set(products.compactMap(\.brand))).sorted()
    }

    func applyFilter(_ filter: ProductListFilter) {
        self.filter = filter
    }
}

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    @State private var isShowingFilter = false

    let title: String
    let selectedTab: EUMTabBar.Tab
    let onBack: () -> Void
    let onFavoriteTap: (String) -> Void
    let onSelectTab: (EUMTabBar.Tab) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onSearchTap: () -> Void
    let cartCount: Int

    private let categories = ["전체", "안전모", "보안경", "안전장갑", "방진마스크", "안전화"]
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    init(
        title: String,
        products: [HomeProduct],
        selectedTab: EUMTabBar.Tab,
        cartCount: Int,
        onBack: @escaping () -> Void,
        onFavoriteTap: @escaping (String) -> Void,
        onSelectTab: @escaping (EUMTabBar.Tab) -> Void,
        onProductTap: @escaping (HomeProduct) -> Void,
        onSearchTap: @escaping () -> Void
    ) {
        self.title = title
        self.selectedTab = selectedTab
        self.cartCount = cartCount
        self.onBack = onBack
        self.onFavoriteTap = onFavoriteTap
        self.onSelectTab = onSelectTab
        self.onProductTap = onProductTap
        self.onSearchTap = onSearchTap
        _viewModel = StateObject(wrappedValue: ProductListViewModel(products: products))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            categorySelector
            productControls

            ScrollView {
                Group {
                    if viewModel.sortedProducts.isEmpty {
                        Text("조건에 맞는 상품이 없어요.")
                            .font(EUMTypography.bodyMedium)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .accessibilityIdentifier("product-list-empty")
                    } else {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
                            ForEach(viewModel.sortedProducts) { product in
                                EUMProductCard(
                                    title: product.title,
                                    price: product.price,
                                    layout: .grid,
                                    imageName: product.imageName,
                                    isSoldOut: product.isSoldOut,
                                    isPriceHidden: product.isPriceHidden,
                                    rating: product.rating,
                                    reviewCount: product.reviewCount,
                                    originalPrice: product.originalPrice,
                                    discountPercentage: product.discountPercentage,
                                    isFavorite: product.isFavorite,
                                    onFavoriteTap: { onFavoriteTap(product.id) },
                                    onTap: { onProductTap(product) }
                                )
                            }
                        }
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                        .padding(.top, 12)
                    }
                }
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)

            EUMTabBar(
                selectedTab: selectedTab,
                cartCount: cartCount,
                accessibilityIDPrefix: "product-list-tab",
                onSelect: onSelectTab
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .fullScreenCover(isPresented: $isShowingFilter) {
            ProductFilterView(filter: viewModel.filter, brands: viewModel.availableBrands) {
                viewModel.applyFilter($0)
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                Image("ProductListBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로 가기")
            .accessibilityIdentifier("product-list-back")

            Spacer(minLength: 0)
            Text(title)
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .lineLimit(1)
            Spacer(minLength: 0)

            Button(action: onSearchTap) {
                Image("DesignSearch")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("검색")
            .accessibilityIdentifier("product-list-search")
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var categorySelector: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = viewModel.selectedCategory == category
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category)
                            .font(EUMTypography.labelMedium)
                            .foregroundStyle(isSelected ? EUMColor.inverseSwiftUI : EUMColor.text2SwiftUI)
                            .padding(.horizontal, 14)
                            .frame(height: 36)
                            .background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: Capsule())
                            .overlay(Capsule().stroke(isSelected ? Color.clear : EUMColor.lineStrongSwiftUI, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.horizontal, EUMSpacing.homeContentInset)
        }
        .scrollIndicators(.hidden)
        .frame(height: 52)
    }

    private var productControls: some View {
        HStack(spacing: 8) {
            Menu {
                ForEach(ProductListViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) { viewModel.sortOption = option }
                }
            } label: {
                HStack(spacing: 4) {
                    Text("정렬: \(viewModel.sortOption.rawValue)")
                    Image("ProductListSort")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, 12)
                .frame(height: 32)
                .overlay(Capsule().stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
            }

            Text("총 \(viewModel.sortedProducts.count)개")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)

            Spacer()

            Button { isShowingFilter = true } label: {
                Image("ProductListFilter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("필터")
            .accessibilityIdentifier("product-list-filter")

            Image("ProductListGrid")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(.leading, 4)
                .accessibilityLabel("그리드 보기")
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .frame(height: 48)
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }
}
