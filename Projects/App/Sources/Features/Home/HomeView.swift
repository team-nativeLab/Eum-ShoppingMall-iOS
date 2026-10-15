import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var selectedTab = EUMTabBar.Tab.home

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case let .content(content):
                if selectedTab == .category {
                    CategoryView(
                        onSearchTap: { selectedTab = .search },
                        onAllProductsTap: {},
                        onCategoryTap: { _ in },
                        onSelectTab: selectTab,
                        cartCount: content.cartCount
                    )
                } else {
                    EUMTopBar(
                        title: "이음산업건설",
                        onMenuTap: {},
                        onNotificationTap: {}
                    )
                    homeContent(content)
                    EUMTabBar(selectedTab: selectedTab, cartCount: content.cartCount, onSelect: selectTab)
                }
            case .failed:
                loadError
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .task {
            if case .loading = viewModel.state {
                await viewModel.load()
            }
        }
    }

    private func selectTab(_ tab: EUMTabBar.Tab) {
        if tab == .home || tab == .category {
            selectedTab = tab
        }
    }

    private func homeContent(_ content: HomeContent) -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(spacing: 16) {
                        EUMSearchBar(text: $searchText, placeholder: "어떤 제품을 찾고 계신가요?")
                            .padding(.horizontal, EUMSpacing.homeContentInset)

                        EUMHeroBanner(pages: [
                            .init(
                                id: "home-hero",
                                eyebrow: content.hero.eyebrow,
                                title: content.hero.title,
                                subtitle: content.hero.subtitle,
                                imageName: content.hero.imageName,
                                actionTitle: content.hero.actionTitle,
                                action: {}
                            )
                        ])
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                    }

                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(content.categories) { category in
                                EUMCategoryItem(title: category.title, iconName: category.iconName) {}
                            }
                        }
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                    }
                    .scrollIndicators(.hidden)
                }

                recommendedSection(content.recommendedProducts)
                bestSellerSection(content.bestSellerProducts)
                quoteBanner
                    .padding(.horizontal, EUMSpacing.homeContentInset)
            }
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
    }

    private func recommendedSection(_ products: [HomeProduct]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            EUMSectionHeader(title: "추천 제품", action: {})
                .padding(.horizontal, EUMSpacing.homeContentInset)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(products) { product in
                        productCard(product, layout: .carousel)
                    }
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
            }
            .scrollIndicators(.hidden)
        }
    }

    private func bestSellerSection(_ products: [HomeProduct]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            EUMSectionHeader(title: "베스트 셀러", action: {})

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                alignment: .leading,
                spacing: 24
            ) {
                ForEach(products) { product in
                    productCard(product, layout: .grid)
                }
            }

            EUMButton(title: "베스트 셀러 전체 보기", kind: .secondary) {}
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private func productCard(_ product: HomeProduct, layout: EUMProductCard.Layout) -> some View {
        EUMProductCard(
            title: product.title,
            price: product.price,
            layout: layout,
            imageName: product.imageName,
            isSoldOut: product.isSoldOut,
            isPriceHidden: product.isPriceHidden,
            isFavorite: product.isFavorite,
            onFavoriteTap: { viewModel.toggleFavorite(productID: product.id) }
        )
    }

    private var quoteBanner: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("CUSTOM ORDER")
                    .font(EUMTypography.overline)
                    .tracking(1.76)
                    .foregroundStyle(EUMColor.text3SwiftUI)

                Text("맞춤 제작·대량 납품 견적")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)

                Text("현장에 맞는 수량·사양으로 제안해 드립니다.")
                    .font(EUMTypography.bodySmall)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {} label: {
                Image("HeroBannerArrow")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 36, height: 36)
                    .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("맞춤 제작 및 대량 납품 견적")
        }
        .padding(20)
        .frame(height: 108)
        .background(EUMColor.backgroundSubtleSwiftUI)
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    private var loadError: some View {
        VStack(spacing: 16) {
            Text("홈 정보를 불러오지 못했어요.")
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
            EUMButton(title: "다시 시도", kind: .secondary) {
                Task { await viewModel.retry() }
            }
            .frame(maxWidth: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
