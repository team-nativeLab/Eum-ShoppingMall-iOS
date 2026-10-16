import SwiftUI

struct HomeLandingContentView: View {
    let content: HomeContent
    @Binding var searchText: String
    let onFavoriteTap: (String) -> Void
    let onQuoteTap: () -> Void
    let onSearchSubmit: () -> Void
    let onHeroTap: () -> Void
    let onCategoryTap: (HomeCategory) -> Void
    let onRecommendedTap: () -> Void
    let onBestSellersTap: () -> Void
    let onProductTap: (HomeProduct) -> Void

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(spacing: 16) {
                        EUMSearchBar(
                            text: $searchText,
                            placeholder: "어떤 제품을 찾고 계신가요?",
                            onSubmit: onSearchSubmit
                        )
                            .padding(.horizontal, EUMSpacing.homeContentInset)

                        EUMHeroBanner(pages: [
                            .init(
                                id: "home-hero",
                                eyebrow: content.hero.eyebrow,
                                title: content.hero.title,
                                subtitle: content.hero.subtitle,
                                imageName: content.hero.imageName,
                                actionTitle: content.hero.actionTitle,
                                action: onHeroTap
                            )
                        ])
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                    }

                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(content.categories) { category in
                                EUMCategoryItem(title: category.title, iconName: category.iconName) {
                                    onCategoryTap(category)
                                }
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
            EUMSectionHeader(title: "추천 제품", action: onRecommendedTap)
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
            EUMSectionHeader(title: "베스트 셀러", action: onBestSellersTap)
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                alignment: .leading,
                spacing: 24
            ) {
                ForEach(products) { product in
                    productCard(product, layout: .grid)
                }
            }
            EUMButton(title: "베스트 셀러 전체 보기", kind: .secondary, action: onBestSellersTap)
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
            onFavoriteTap: { onFavoriteTap(product.id) },
            onTap: { onProductTap(product) }
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

            Button(action: onQuoteTap) {
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
}
