import SwiftUI

struct RecentlyViewedView: View {
    @StateObject private var viewModel = RecentlyViewedViewModel()

    let onBack: () -> Void
    let onProductTap: (HomeProduct) -> Void

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    retentionNotice
                    dateGroups
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("최근 본 상품")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack {
                Button(action: onBack) {
                    Image("ProductDetailBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("마이페이지로 돌아가기")
                Spacer()
                Button("전체 삭제", action: viewModel.removeAll)
                    .font(EUMTypography.labelMedium)
                    .tracking(-0.07)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var retentionNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("DeliveryInfo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 2)
            Text("최근 본 상품은 최대 0개까지 보관합니다.")
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
    }

    @ViewBuilder
    private var dateGroups: some View {
        if viewModel.groups.isEmpty {
            Text("최근 본 상품이 없습니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, minHeight: 220)
        } else {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.groups) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(group.date)
                            .font(EUMTypography.labelMedium)
                            .tracking(-0.07)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                            ForEach(group.products) { product in
                                productCard(product)
                            }
                        }
                    }
                }
            }
        }
    }

    private func productCard(_ product: HomeProduct) -> some View {
        EUMProductCard(
            title: product.title,
            price: product.price,
            layout: .grid,
            imageName: product.imageName,
            isSoldOut: product.isSoldOut,
            isPriceHidden: product.isPriceHidden,
            hiddenPriceBadgeTitle: "견적 상품",
            showsFavoriteButton: false,
            onTap: { onProductTap(product) }
        )
        .overlay(alignment: .topTrailing) {
            Button {
                viewModel.remove(productID: product.id)
            } label: {
                Image("RecentlyViewedRemove")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("최근 본 상품 삭제")
            .padding(.top, 8)
            .padding(.trailing, 8)
        }
    }
}

struct RecentlyViewedViewPreview: PreviewProvider {
    static var previews: some View {
        RecentlyViewedView(onBack: {}, onProductTap: { _ in })
    }
}
