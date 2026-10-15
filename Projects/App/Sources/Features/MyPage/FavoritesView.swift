import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    let onBack: () -> Void
    let onProductTap: (HomeProduct) -> Void

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView {
                VStack(spacing: 16) {
                    countAndSort
                    productGrid
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if viewModel.isEditing {
                EUMButton(title: "선택 삭제 (\(viewModel.selectedCount))", size: .large) {
                    viewModel.removeSelected()
                }
                .disabled(viewModel.selectedCount == 0)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 12)
                .background(EUMColor.backgroundSwiftUI)
            }
        }
    }

    private var topBar: some View {
        ZStack {
            Text("찜한 상품")
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
                Button(viewModel.isEditing ? "완료" : "편집", action: viewModel.toggleEditing)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(minWidth: 44, minHeight: 44, alignment: .trailing)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var countAndSort: some View {
        HStack {
            Text("전체 0개")
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
            Spacer()
            Menu {
                ForEach(FavoritesSortOption.allCases) { option in
                    Button(option.rawValue) { viewModel.sortOption = option }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(viewModel.sortOption.rawValue)
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(EUMColor.text2SwiftUI)
            }
            .accessibilityLabel("정렬 기준, \(viewModel.sortOption.rawValue)")
        }
        .frame(height: 20)
    }

    @ViewBuilder
    private var productGrid: some View {
        if viewModel.sortedProducts.isEmpty {
            Text("찜한 상품이 없습니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, minHeight: 220)
        } else {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                ForEach(viewModel.sortedProducts) { product in
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
                            if viewModel.isEditing {
                                viewModel.toggleSelection(productID: product.id)
                            } else {
                                viewModel.removeFavorite(productID: product.id)
                            }
                        },
                        onTap: {
                            if viewModel.isEditing {
                                viewModel.toggleSelection(productID: product.id)
                            } else {
                                onProductTap(product)
                            }
                        }
                    )
                    .overlay(alignment: .topLeading) {
                        if viewModel.isEditing, viewModel.selectedProductIDs.contains(product.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .padding(12)
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
        }
    }
}

struct FavoritesViewPreview: PreviewProvider {
    static var previews: some View {
        FavoritesView(onBack: {}, onProductTap: { _ in })
    }
}
