import SwiftUI

struct CategoryView: View {
    enum ContentMode {
        case products
        case brands
    }

    var onSearchTap: () -> Void
    var onAllProductsTap: () -> Void
    var onCategoryTap: (String) -> Void
    var onSelectTab: (EUMTabBar.Tab) -> Void
    var cartCount: Int

    @State private var contentMode: ContentMode = .products

    private let categories: [HomeCategory] = [
        HomeCategory(id: "ppe", title: "개인보호장비", iconName: "CategoryHardHat"),
        HomeCategory(id: "uniform", title: "작업복/유니폼", iconName: "CategoryClothing"),
        HomeCategory(id: "road", title: "교통·도로 안전", iconName: "CategoryRoad"),
        HomeCategory(id: "fire", title: "소방·방재용품", iconName: "CategoryFire"),
        HomeCategory(id: "industry", title: "산업 현장용품", iconName: "CategoryIndustry"),
        HomeCategory(id: "security", title: "보안·감시", iconName: "CategorySecurity"),
        HomeCategory(id: "life", title: "생활 안전용품", iconName: "CategoryLife"),
        HomeCategory(id: "custom", title: "맞춤 제작/납품", iconName: "CategoryCustom")
    ]

    var body: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView {
                VStack(spacing: 8) {
                    contentModeSelector

                    if contentMode == .products {
                        productCategories
                    } else {
                        Text("브랜드 목록은 A-33 화면 작업에서 연결됩니다.")
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text3SwiftUI)
                            .frame(maxWidth: .infinity, minHeight: 240)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)

            EUMTabBar(selectedTab: .category, cartCount: cartCount, onSelect: onSelectTab)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var productCategories: some View {
        VStack(spacing: 0) {
            Button(action: onAllProductsTap) {
                HStack {
                    Text("전체 제품 보기")
                        .font(EUMTypography.labelLarge)
                        .tracking(-0.16)
                        .foregroundStyle(EUMColor.text1SwiftUI)

                    Spacer()

                    Image("SectionChevron")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(EUMColor.text3SwiftUI)
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .frame(height: 56)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)
                .padding(.horizontal, EUMSpacing.homeContentInset)

            VStack(spacing: 0) {
                ForEach(categories) { category in
                    EUMCategoryItem(
                        title: category.title,
                        iconName: category.iconName,
                        layout: .row
                    ) {
                        onCategoryTap(category.id)
                    }
                    .padding(.horizontal, EUMSpacing.homeContentInset)
                }
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 0) {
            Color.clear
                .frame(width: 44, height: 44)

            Spacer(minLength: 0)

            Text("카테고리")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .accessibilityAddTraits(.isHeader)

            Spacer(minLength: 0)

            Button(action: onSearchTap) {
                Image("DesignSearch")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("검색")
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(EUMColor.backgroundSwiftUI)
    }

    private var contentModeSelector: some View {
        HStack(spacing: 4) {
            modeButton(title: "제품", mode: .products)
            modeButton(title: "브랜드", mode: .brands)
        }
        .padding(4)
        .background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .padding(.vertical, 12)
    }

    private func modeButton(title: String, mode: ContentMode) -> some View {
        let isSelected = contentMode == mode

        return Button {
            contentMode = mode
        } label: {
            Text(title)
                .font(EUMTypography.labelMedium)
                .tracking(-0.07)
                .foregroundStyle(isSelected ? EUMColor.text1SwiftUI : EUMColor.text2SwiftUI)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: EUMRadius.medium)
                            .fill(EUMColor.backgroundSwiftUI)
                            .shadow(color: EUMColor.text1SwiftUI.opacity(0.06), radius: 3, x: 0, y: 1)
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
