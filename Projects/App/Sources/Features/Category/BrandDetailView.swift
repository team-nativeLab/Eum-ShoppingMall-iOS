import SwiftUI

struct BrandDetailView: View {
    @StateObject private var viewModel: BrandDetailViewModel
    @State private var presentedMessage: String?

    let onBack: () -> Void
    let onBrandSelected: (String) -> Void
    let onShowAllBrands: () -> Void
    let onSelectTab: (EUMTabBar.Tab) -> Void
    let onFavoriteTap: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let cartCount: Int

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    init(
        brandID: String,
        cartCount: Int,
        onBack: @escaping () -> Void,
        onBrandSelected: @escaping (String) -> Void,
        onShowAllBrands: @escaping () -> Void,
        onSelectTab: @escaping (EUMTabBar.Tab) -> Void,
        onFavoriteTap: @escaping (String) -> Void,
        onProductTap: @escaping (HomeProduct) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: BrandDetailViewModel(brandID: brandID))
        self.cartCount = cartCount
        self.onBack = onBack
        self.onBrandSelected = onBrandSelected
        self.onShowAllBrands = onShowAllBrands
        self.onSelectTab = onSelectTab
        self.onFavoriteTap = onFavoriteTap
        self.onProductTap = onProductTap
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        hero(proxy: proxy)
                        story
                        products.id("brand-products")
                        otherBrands
                    }
                }
                .scrollIndicators(.hidden)
            }
            EUMTabBar(selectedTab: .category, cartCount: cartCount, onSelect: onSelectTab)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }
}

private extension BrandDetailView {
    private var topBar: some View {
        ZStack {
            Text(viewModel.brandName)
                .font(EUMTypography.labelLarge)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductListBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("브랜드 목록으로 돌아가기")
                Spacer()
                Button {
                    presentedMessage = "브랜드 링크 공유는 준비 중입니다."
                } label: {
                    Image("ProductDetailShare")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("브랜드 공유")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private func hero(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("BrandDetailHero")
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .accessibilityLabel("브랜드 창고 이미지")

            VStack(alignment: .leading, spacing: 20) {
                BrandLogoPlaceholder()
                    .frame(width: 120, height: 48)
                    .background(EUMColor.inverseSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.brandName)
                        .font(.custom("NotoSansKR-Bold", size: 26, relativeTo: .title))
                        .foregroundStyle(EUMColor.inverseSwiftUI)
                    Text("BRAND \(viewModel.brandID.last.map(String.init) ?? "A") · 개인보호장비")
                        .font(EUMTypography.captionMedium)
                        .foregroundStyle(EUMColor.inverseSecondarySwiftUI)
                }
                Text("브랜드 한 줄 소개가 들어갑니다. 서버에서 받은 소개 문구를 최대 세 줄까지 표시합니다.")
                    .font(EUMTypography.bodyMedium)
                    .foregroundStyle(EUMColor.inverseSecondarySwiftUI)
                    .lineLimit(3)
                Button {
                    withAnimation { proxy.scrollTo("brand-products", anchor: .top) }
                } label: {
                    HStack(spacing: 8) {
                        Text("제품 00개 보기")
                            .font(EUMTypography.labelLarge)
                        Image("SectionChevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(-90))
                    }
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(EUMColor.inverseSwiftUI, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.text1SwiftUI)
    }

    private var story: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("브랜드 스토리")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text3SwiftUI)
            Text("브랜드 스토리 제목이 들어갑니다.")
                .font(EUMTypography.heading2)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Text(viewModel.story)
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .lineLimit(viewModel.isStoryExpanded ? nil : 6)
                .fixedSize(horizontal: false, vertical: true)
            Button {
                withAnimation { viewModel.toggleStoryExpansion() }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.isStoryExpanded ? "접기" : "더 보기")
                    Image("SectionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(viewModel.isStoryExpanded ? 90 : -90))
                }
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(height: 44)
            }
            .buttonStyle(.plain)
            brandFacts
        }
        .padding(.horizontal, 20)
        .padding(.top, 48)
        .padding(.bottom, 24)
    }

    private var brandFacts: some View {
        VStack(spacing: 0) {
            factRow(title: "주력 분야", value: "분야명")
            factRow(title: "주요 인증", value: "인증명 0종")
            factRow(title: "원산지", value: "원산지")
        }
        .padding(.top, 8)
    }

    private func factRow(title: String, value: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(width: 88, alignment: .leading)
            Text(value)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer(minLength: 0)
        }
        .font(EUMTypography.bodySmall)
        .frame(height: 45)
        .overlay(alignment: .bottom) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }
}

private extension BrandDetailView {
    private var products: some View {
        VStack(spacing: 0) {
            productHeader
            categoryChips
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.filteredProducts) { entry in
                    EUMProductCard(
                        title: entry.product.title,
                        price: entry.product.price,
                        layout: .grid,
                        imageName: entry.product.imageName,
                        isSoldOut: entry.product.isSoldOut,
                        isPriceHidden: entry.product.isPriceHidden,
                        isFavorite: viewModel.isFavorite(entry.product),
                        onFavoriteTap: {
                            viewModel.toggleFavorite(productID: entry.id)
                            onFavoriteTap(entry.id)
                        },
                        onTap: { onProductTap(entry.product) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            Button {
                presentedMessage = "표시할 목업 상품을 모두 불러왔습니다."
            } label: {
                Text("더 보기 (6/00)")
                    .font(EUMTypography.bodySmall)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .overlay(alignment: .top) { Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1) }
    }

    private var productHeader: some View {
        HStack {
            Text("제품 00개")
                .font(EUMTypography.heading3)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer()
            Menu {
                ForEach(BrandDetailViewModel.SortOption.allCases) { option in
                    Button(option.rawValue) { viewModel.sortOption = option }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.sortOption.rawValue)
                    Image("ProductListSort")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .padding(.bottom, 8)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories, id: \.self) { category in
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
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }

    private var otherBrands: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("다른 브랜드")
                .font(EUMTypography.heading3)
                .foregroundStyle(EUMColor.text1SwiftUI)
            VStack(spacing: 0) {
                ForEach(viewModel.otherBrands.indices, id: \.self) { index in
                    let name = viewModel.otherBrands[index]
                    Button { onBrandSelected(viewModel.otherBrandIDs[index]) } label: {
                        HStack(spacing: 12) {
                            BrandLogoPlaceholder()
                                .frame(width: 44, height: 44)
                                .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.small))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(name)
                                    .font(EUMTypography.labelMedium)
                                    .foregroundStyle(EUMColor.text1SwiftUI)
                                Text("제품 00개")
                                    .font(EUMTypography.captionRegular)
                                    .foregroundStyle(EUMColor.text3SwiftUI)
                            }
                            Spacer()
                            Image("SectionChevron")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(-90))
                                .foregroundStyle(EUMColor.text3SwiftUI)
                        }
                        .frame(height: 72)
                        .contentShape(Rectangle())
                        .overlay(alignment: .bottom) {
                            if index < viewModel.otherBrands.count - 1 {
                                Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(name), 제품 00개")
                }
            }
            .padding(.horizontal, 16)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
            Button(action: onShowAllBrands) {
                HStack(spacing: 4) {
                    Text("전체 브랜드 보기")
                    Image("SectionChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .rotationEffect(.degrees(-90))
                }
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .frame(height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(EUMColor.backgroundSubtleSwiftUI)
    }
}

private struct BrandLogoPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: EUMRadius.small)
            .fill(EUMColor.surfaceSwiftUI)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundStyle(EUMColor.lineStrongSwiftUI)
            }
            .accessibilityHidden(true)
    }
}
