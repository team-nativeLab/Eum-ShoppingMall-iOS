import SwiftUI

@MainActor
final class ProductDetailViewModel: ObservableObject {
    enum Tab: String, CaseIterable, Identifiable {
        case information = "정보"
        case shipping = "배송·교환"
        case reviews = "리뷰 (0)"
        case inquiries = "문의 (0)"

        var id: String { rawValue }
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
    let onBack: () -> Void
    let onQuoteTap: () -> Void
    let onOpenCart: () -> Void
    let onPurchase: () -> Void
    let onRelatedProductTap: (HomeProduct) -> Void

    init(
        product: HomeProduct,
        onBack: @escaping () -> Void,
        onQuoteTap: @escaping () -> Void,
        onOpenCart: @escaping () -> Void,
        onPurchase: @escaping () -> Void,
        onRelatedProductTap: @escaping (HomeProduct) -> Void
    ) {
        self.product = product
        self.onBack = onBack
        self.onQuoteTap = onQuoteTap
        self.onOpenCart = onOpenCart
        self.onPurchase = onPurchase
        self.onRelatedProductTap = onRelatedProductTap
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(isFavorite: product.isFavorite))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        gallery
                        productSummary

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
            Image("ProductPlaceholder")
                .resizable()
                .scaledToFill()
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

    private var productSummary: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text("브랜드명")
                                .font(EUMTypography.captionMedium)
                                .foregroundStyle(EUMColor.text3SwiftUI)

                            if product.isPriceHidden {
                                Text("견적 상품")
                                    .font(EUMTypography.labelExtraSmall)
                                    .foregroundStyle(EUMColor.text2SwiftUI)
                                    .padding(.horizontal, 6)
                                    .frame(height: 20)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                            }
                        }

                        Text(product.title)
                            .font(EUMTypography.heading2)
                            .tracking(-0.44)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                    }

                    if product.isPriceHidden {
                        Text("가격 문의")
                            .font(EUMTypography.heading2)
                            .foregroundStyle(EUMColor.text2SwiftUI)
                    } else if let price = product.price {
                        Text(price)
                            .font(Font.custom("NotoSansKR-Bold", size: 24, relativeTo: .title))
                            .tracking(-0.36)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                    }
                }

                Text("제품에 대한 간단한 설명이 들어갑니다.\n안전한 작업을 위한 필수 아이템입니다.")
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.075)
                    .lineSpacing(0)
                    .foregroundStyle(EUMColor.text2SwiftUI)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 8) {
                ProductDetailKeyValueRow(label: "배송", value: "일반 배송 (2~3일) · 무료", labelWidth: 72)
                ProductDetailKeyValueRow(label: "인증", value: "KC 인증 0000-0000", labelWidth: 72)
                ProductDetailKeyValueRow(label: "제조사", value: "제조사명", labelWidth: 72)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(EUMColor.backgroundSubtleSwiftUI)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }

    private func detailTabs(onSelect: @escaping (ProductDetailViewModel.Tab) -> Void) -> some View {
        HStack(spacing: 0) {
            ForEach(ProductDetailViewModel.Tab.allCases) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    VStack(spacing: 0) {
                        Text(tab.rawValue)
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
            isDetailExpanded: $viewModel.isDetailExpanded,
            onQuoteTap: onQuoteTap
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
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("가격 문의 상품은 견적 문의로 구매할 수 있습니다.")
                        .font(EUMTypography.bodySmall)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(EUMColor.surfaceSwiftUI)
            }

            HStack(spacing: 8) {
                Button {
                    viewModel.isFavorite.toggle()
                } label: {
                    Image("ProductDetailFavorite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 56, height: 56)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(EUMColor.lineStrongSwiftUI, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.isFavorite ? "찜 취소" : "찜하기")

                if product.isPriceHidden {
                    EUMButton(title: "견적 문의", size: .large) {
                        viewModel.isOptionsPresented = true
                    }
                } else {
                    EUMButton(title: "장바구니 담기", size: .large) {
                    viewModel.isOptionsPresented = true
                    }

                EUMButton(title: "바로 구매", kind: .secondary, size: .large) {
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
