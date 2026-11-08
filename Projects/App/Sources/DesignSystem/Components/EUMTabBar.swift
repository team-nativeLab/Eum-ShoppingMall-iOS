import SwiftUI

struct EUMTabBar: View {
    enum Tab: String, CaseIterable, Equatable, Identifiable {
        case home = "홈"
        case category = "카테고리"
        case search = "검색"
        case cart = "장바구니"
        case account = "마이"

        var id: String { rawValue }

        var assetName: String {
            switch self {
            case .home: "TabHome"
            case .category: "TabCategory"
            case .search: "TabSearch"
            case .cart: "TabCart"
            case .account: "TabUser"
            }
        }
    }

    let selectedTab: Tab
    var cartCount: Int = 0
    var accessibilityIDPrefix = "tab"
    var onSelect: (Tab) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases) { tab in
                    Button {
                        onSelect(tab)
                    } label: {
                        VStack(spacing: 3) {
                            Image(tab.assetName)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .overlay(alignment: .topTrailing) {
                                    if tab == .cart && cartCount > 0 {
                                        Text(cartCount > 99 ? "99+" : "\(cartCount)")
                                            .font(EUMTypography.labelExtraSmall)
                                            .foregroundStyle(EUMColor.inverseSwiftUI)
                                            .padding(.horizontal, 4)
                                            .frame(minWidth: 16, minHeight: 16)
                                            .background(EUMColor.text1SwiftUI, in: Capsule())
                                            .offset(x: 10, y: -4)
                                    }
                                }

                            Text(tab.rawValue)
                                .font(EUMTypography.labelExtraSmall)
                                .lineLimit(1)
                        }
                        .foregroundStyle(tab == selectedTab ? EUMColor.text1SwiftUI : EUMColor.text3SwiftUI)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56, alignment: .top)
                        .padding(.top, 7)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab.rawValue)
                    .accessibilityIdentifier("\(accessibilityIDPrefix)-\(tab.id)")
                    .accessibilityAddTraits(tab == selectedTab ? .isSelected : [])
                }
            }
        }
        .background {
            EUMColor.backgroundSwiftUI
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(EUMColor.lineSwiftUI)
                        .frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        }
        .frame(height: 56)
    }
}
