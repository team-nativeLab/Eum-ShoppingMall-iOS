import SwiftUI

@MainActor
final class ProductDetailViewModel: ObservableObject {
    enum Tab: String, CaseIterable, Identifiable {
        case information = "정보"
        case shipping = "배송·교환"
        case reviews = "리뷰"
        case inquiries = "문의"

        var id: String { rawValue }

        func title(reviewCount: Int) -> String {
            switch self {
            case .reviews: "리뷰 (\(reviewCount))"
            case .inquiries: "문의 (0)"
            default: rawValue
            }
        }
    }

    @Published var selectedTab: Tab = .information
    @Published var isFavorite: Bool
    @Published var isDetailExpanded = false
    @Published var showCartConfirmation = false
    @Published var isOptionsPresented = false

    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel

    let product: HomeProduct
    private let detail: ProductDetailContent
    let onBack: () -> Void
    let onQuoteTap: () -> Void
    let onOpenCart: () -> Void
    let onPurchase: () -> Void
    let onRelatedProductTap: (HomeProduct) -> Void
    let onProductInquiry: () -> Void
    let onShowAllReviews: () -> Void
    let onShippingDetails: () -> Void

    init(
        product: HomeProduct,
        onBack: @escaping () -> Void,
        onQuoteTap: @escaping () -> Void,
        onOpenCart: @escaping () -> Void,
        onPurchase: @escaping () -> Void,
        onRelatedProductTap: @escaping (HomeProduct) -> Void,
        onProductInquiry: @escaping () -> Void,
        onShowAllReviews: @escaping () -> Void,
        onShippingDetails: @escaping () -> Void
    ) {
        self.product = product
        detail = ProductDetailContent(product: product)
        self.onBack = onBack
        self.onQuoteTap = onQuoteTap
        self.onOpenCart = onOpenCart
        self.onPurchase = onPurchase
        self.onRelatedProductTap = onRelatedProductTap
        self.onProductInquiry = onProductInquiry
        self.onShowAllReviews = onShowAllReviews
        self.onShippingDetails = onShippingDetails
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(isFavorite: product.isFavorite))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        gallery
                        ProductDetailSummaryView(product: product, detail: detail)

                        Section {
                            detailSections
                        } header: {
                            detailTabs { tab in
                                viewModel.selectedTab = tab
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(tabScrollTarget(tab), anchor: .top)
                                }
                            }
                        }

                        relatedSection
                            .id("related")
                    }
                }
                .scrollIndicators(.hidden)
            }

            buyBar
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .alert("장바구니에 담았습니다.", isPresented: $viewModel.showCartConfirmation) {
            Button("확인", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.isOptionsPresented) {
            ProductOptionsSheet(
                onAddToCart: { viewModel.showCartConfirmation = true },
                onPrimaryAction: {
                    viewModel.isOptionsPresented = false
                    if product.isPriceHidden {
                        onQuoteTap()
                    } else {
                        onPurchase()
                    }
                },
                isPriceHidden: product.isPriceHidden
            )
            .presentationDetents([.height(product.isPriceHidden ? 636 : 618)])
            .presentationCornerRadius(12)
            .presentationDragIndicator(.hidden)
            .presentationBackground(EUMColor.backgroundSwiftUI)
        }
    }

    private var topBar: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                Image("ProductDetailBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로 가기")
            .accessibilityIdentifier("product-detail-back")

            Spacer()

            ShareLink(item: product.title) {
                Image("ProductDetailShare")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("공유")

            Button(action: onOpenCart) {
                Image("ProductDetailCart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("장바구니")
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var gallery: some View {
        ZStack(alignment: .bottomTrailing) {
            ProductDetailImagePlaceholder()
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("1 / 5")
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.inverseSwiftUI)
                .padding(.horizontal, 10)
                .frame(height: 24)
                .background(EUMColor.text1SwiftUI.opacity(0.48), in: Capsule())
                .padding(16)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .frame(height: 358, alignment: .top)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("상품 이미지, 5장 중 1장")
    }

    private func detailTabs(onSelect: @escaping (ProductDetailViewModel.Tab) -> Void) -> some View {
        HStack(spacing: 0) {
            ForEach(ProductDetailViewModel.Tab.allCases) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    VStack(spacing: 0) {
                        Text(tab.title(reviewCount: detail.reviewCount))
                            .font(EUMTypography.labelMedium)
                            .tracking(-0.07)
                            .foregroundStyle(tab == viewModel.selectedTab ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)

                        Rectangle()
                            .fill(tab == viewModel.selectedTab ? EUMColor.text1SwiftUI : .clear)
                            .frame(height: tab == viewModel.selectedTab ? 2 : 1)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(tab == viewModel.selectedTab ? .isSelected : [])
            }
        }
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) { EUMColor.lineSwiftUI.frame(height: 1) }
        .overlay(alignment: .bottom) { EUMColor.lineSwiftUI.frame(height: 1) }
    }

    private var detailSections: some View {
        ProductDetailSections(
            detail: detail,
            isDetailExpanded: $viewModel.isDetailExpanded,
            onQuoteTap: onQuoteTap,
            onProductInquiry: onProductInquiry,
            onShowAllReviews: onShowAllReviews,
            onShippingDetails: onShippingDetails
        )
    }

    private var relatedSection: some View {
        ProductDetailRelatedSection(onProductTap: onRelatedProductTap)
    }

    private var buyBar: some View {
        VStack(spacing: 0) {
            if product.isPriceHidden {
                HStack(spacing: 8) {
                    Image("ProductDetailInfo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                    Text("가격 문의 상품은 견적 문의로 구매할 수 있습니다.")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.dangerSwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(EUMColor.dangerBackgroundSwiftUI)
            }

            HStack(spacing: 8) {
                Button {
                    viewModel.isFavorite.toggle()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(viewModel.isFavorite ? EUMColor.dangerSwiftUI : EUMColor.text1SwiftUI)
                        .frame(width: 56, height: 56)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.isFavorite ? "찜 취소" : "찜하기")

                if product.isPriceHidden {
                    EUMButton(title: "장바구니 담기", size: .large) {
                        viewModel.isOptionsPresented = true
                    }

                    EUMButton(title: "견적 문의", kind: .secondary, size: .large) {
                        viewModel.isOptionsPresented = true
                    }
                } else {
                    EUMButton(title: "장바구니 담기", kind: .secondary, size: .large) {
                        viewModel.isOptionsPresented = true
                    }

                    EUMButton(title: "바로 구매", size: .large) {
                        viewModel.isOptionsPresented = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .overlay(alignment: .top) { EUMColor.lineSwiftUI.frame(height: 1) }

            Color.clear.frame(height: 34)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea(edges: .bottom))
    }

    private func tabScrollTarget(_ tab: ProductDetailViewModel.Tab) -> String {
        switch tab {
        case .information: "information"
        case .shipping: "shipping"
        case .reviews: "reviews"
        case .inquiries: "inquiries"
        }
    }
}
