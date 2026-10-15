import SwiftUI

@MainActor
final class SearchResultsViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case recommended = "추천순"
        case priceAscending = "낮은 가격순"
        case priceDescending = "높은 가격순"

        var id: String { rawValue }
    }

    enum PriceFilter: String, CaseIterable, Identifiable {
        case all = "전체 상품"
        case priced = "가격 표시 상품"
        case quote = "견적 상품"

        var id: String { rawValue }
    }

    @Published var selectedCategory = "전체"
    @Published var sortOption: SortOption = .recommended
    @Published var priceFilter: PriceFilter = .all
    @Published private(set) var products: [HomeProduct]

    init(products: [HomeProduct]) {
        self.products = Array(products.prefix(4).enumerated()).map { index, product in
            HomeProduct(
                id: product.id,
                title: product.title,
                price: product.price,
                imageName: product.imageName,
                isFavorite: product.isFavorite,
                isSoldOut: false,
                isPriceHidden: index == 3
            )
        }
    }

    var visibleProducts: [HomeProduct] {
        let filtered = products.filter { product in
            switch priceFilter {
            case .all: true
            case .priced: !product.isPriceHidden
            case .quote: product.isPriceHidden
            }
        }

        switch sortOption {
        case .recommended:
            return filtered
        case .priceAscending:
            return filtered.sorted { ($0.price ?? "").localizedStandardCompare($1.price ?? "") == .orderedAscending }
        case .priceDescending:
            return filtered.sorted { ($0.price ?? "").localizedStandardCompare($1.price ?? "") == .orderedDescending }
        }
    }

    func toggleFavorite(productID: String) {
        products = products.map { product in
            var updated = product
            if updated.id == productID { updated.isFavorite.toggle() }
            return updated
        }
    }
}

struct SearchResultsView: View {
    @Binding var searchText: String
    @StateObject private var viewModel: SearchResultsViewModel

    let cartCount: Int
    let onBackToSearch: () -> Void
    let onCancel: () -> Void
    let onFavoriteTap: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onSelectTab: (EUMTabBar.Tab) -> Void

    private let categories = ["전체", "개인보호장비", "작업복/유니폼", "산업 현장용품"]
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    init(
        searchText: Binding<String>,
        products: [HomeProduct],
        cartCount: Int,
        onBackToSearch: @escaping () -> Void,
        onCancel: @escaping () -> Void,
        onFavoriteTap: @escaping (String) -> Void,
        onProductTap: @escaping (HomeProduct) -> Void,
        onSelectTab: @escaping (EUMTabBar.Tab) -> Void
    ) {
        _searchText = searchText
        _viewModel = StateObject(wrappedValue: SearchResultsViewModel(products: products))
        self.cartCount = cartCount
        self.onBackToSearch = onBackToSearch
        self.onCancel = onCancel
        self.onFavoriteTap = onFavoriteTap
        self.onProductTap = onProductTap
        self.onSelectTab = onSelectTab
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            resultsBody
            EUMTabBar(selectedTab: .search, cartCount: cartCount, onSelect: onSelectTab)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        HStack(spacing: 4) {
            Button(action: onBackToSearch) {
                Image("ProductListBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("검색 화면으로 돌아가기")

            HStack(spacing: 8) {
                Image("DesignSearch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)

                TextField("검색어", text: $searchText)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .submitLabel(.search)
                    .accessibilityLabel("검색어")

                Button {
                    searchText = ""
                } label: {
                    Image("SearchClear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("검색어 지우기")
            }
            .padding(.leading, 16)
            .padding(.trailing, 4)
            .frame(height: 44)
            .background(EUMColor.surfaceSwiftUI, in: Capsule())

            Button("취소", action: onCancel)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.075)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(width: 44, height: 44)
                .buttonStyle(.plain)
                .accessibilityLabel("검색 취소")
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var resultsBody: some View {
        ScrollView {
            VStack(spacing: 0) {
                categorySelector
                resultsToolbar
                productGrid
            }
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var categorySelector: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = viewModel.selectedCategory == category
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text("\(category) 00")
                            .font(EUMTypography.labelMedium)
                            .tracking(-0.07)
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
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .frame(height: 52)
    }

    private var resultsToolbar: some View {
        HStack(spacing: 16) {
            Text("'\(searchText)' 검색 결과 00개")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            Menu {
                ForEach(SearchResultsViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) { viewModel.sortOption = option }
                }
            } label: {
                HStack(spacing: 4) {
                    Image("SearchSort")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(viewModel.sortOption.rawValue)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .accessibilityLabel("정렬 방식")

            Menu {
                ForEach(SearchResultsViewModel.PriceFilter.allCases) { filter in
                    Button(filter.rawValue) { viewModel.priceFilter = filter }
                }
            } label: {
                HStack(spacing: 4) {
                    Image("SearchFilter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("필터")
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                }
                .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .accessibilityLabel("상품 필터")

            Image("ProductListGrid")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .accessibilityLabel("그리드 보기")
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .frame(height: 48)
    }

    private var productGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
            ForEach(viewModel.visibleProducts) { product in
                EUMProductCard(
                    title: product.title,
                    price: product.price,
                    layout: .grid,
                    imageName: product.imageName,
                    isSoldOut: product.isSoldOut,
                    isPriceHidden: product.isPriceHidden,
                    hiddenPriceBadgeTitle: "견적 상품",
                    isFavorite: product.isFavorite,
                    onFavoriteTap: {
                        viewModel.toggleFavorite(productID: product.id)
                        onFavoriteTap(product.id)
                    },
                    onTap: { onProductTap(product) }
                )
            }
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.top, 8)
    }
}
