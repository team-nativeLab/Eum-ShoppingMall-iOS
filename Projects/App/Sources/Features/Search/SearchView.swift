import SwiftUI

struct SearchView: View {
    @Binding var searchText: String

    let cartCount: Int
    let products: [HomeProduct]
    let onFavoriteTap: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onBack: () -> Void
    let onSelectTab: (EUMTabBar.Tab) -> Void

    @State private var recentSearches = ["안전모", "작업복", "안전장갑", "교통안전봉", "소화기"]
    @State private var showsResults = false
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        if showsResults {
            SearchResultsView(
                searchText: $searchText,
                products: products,
                cartCount: cartCount,
                onBackToSearch: { showsResults = false },
                onCancel: onBack,
                onFavoriteTap: onFavoriteTap,
                onProductTap: onProductTap,
                onSelectTab: onSelectTab
            )
        } else {
            searchLanding
        }
    }

    private var searchLanding: some View {
        VStack(spacing: 0) {
            searchTopBar
            searchBody
            EUMTabBar(selectedTab: .search, cartCount: cartCount, onSelect: onSelectTab)
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var searchTopBar: some View {
        HStack(spacing: 4) {
            Button(action: onBack) {
                Image("ProductDetailBack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로 가기")

            HStack(spacing: 8) {
                Image("DesignSearch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)

                TextField("검색어를 입력해 주세요", text: $searchText)
                    .font(EUMTypography.bodyMedium)
                    .tracking(-0.5)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .submitLabel(.search)
                    .onSubmit { showsResults = true }
                    .focused($isSearchFocused)
                    .accessibilityLabel("검색어")
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(EUMColor.backgroundSwiftUI, in: Capsule())
            .overlay(Capsule().stroke(EUMColor.text1SwiftUI, lineWidth: 1.5))

            Button("취소", action: onBack)
                .font(EUMTypography.bodyMedium)
                .tracking(-0.5)
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

    private var searchBody: some View {
        VStack(spacing: 24) {
            recentSearchSection

            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)

            popularSearchSection
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var recentSearchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("최근 검색어")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Button("전체 삭제") {
                    recentSearches.removeAll()
                }
                .font(EUMTypography.captionMedium)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .buttonStyle(.plain)
                .disabled(recentSearches.isEmpty)
            }

            if !recentSearches.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(recentSearches, id: \.self) { term in
                        Button {
                            searchText = term
                            showsResults = true
                        } label: {
                            Text(term)
                                .font(EUMTypography.labelMedium)
                                .tracking(-0.07)
                                .foregroundStyle(EUMColor.text1SwiftUI)
                                .padding(.horizontal, 14)
                                .frame(height: 36)
                                .background(EUMColor.surfaceSwiftUI, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var popularSearchSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("인기 검색어")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.16)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Text("기준 00:00")
                    .font(EUMTypography.captionMedium)
                    .foregroundStyle(EUMColor.text3SwiftUI)
            }

            HStack(alignment: .top, spacing: 16) {
                popularSearchColumn(1...5)
                popularSearchColumn(6...10)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func popularSearchColumn(_ ranks: ClosedRange<Int>) -> some View {
        VStack(spacing: 0) {
            ForEach(ranks, id: \.self) { rank in
                Button {
                    searchText = "안전모"
                    showsResults = true
                } label: {
                    HStack(spacing: 8) {
                        Text("\(rank)")
                            .font(EUMTypography.labelMedium)
                            .foregroundStyle(rank > 3 ? EUMColor.text3SwiftUI : EUMColor.text1SwiftUI)
                            .frame(width: 20, alignment: .leading)

                        Text("인기 검색어")
                            .font(EUMTypography.bodySmall)
                            .foregroundStyle(EUMColor.text1SwiftUI)
                            .lineLimit(1)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var cursorX: CGFloat = 0
        var cursorY: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if cursorX > 0, cursorX + size.width > width {
                cursorX = 0
                cursorY += rowHeight + spacing
                rowHeight = 0
            }
            cursorX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: width, height: cursorY + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var cursorX = bounds.minX
        var cursorY = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if cursorX > bounds.minX, cursorX + size.width > bounds.maxX {
                cursorX = bounds.minX
                cursorY += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: cursorX, y: cursorY), proposal: ProposedViewSize(size))
            cursorX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
