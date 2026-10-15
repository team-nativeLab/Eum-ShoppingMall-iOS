import SwiftUI

struct CartItem: Identifiable, Equatable {
    let id: String
    let title: String
    let option: String
    let isSoldOut: Bool
    var quantity: Int
    var isSelected: Bool
    var isQuoteProduct = false

    static let mockItems = [
        CartItem(id: "cart-1", title: "제품명", option: "사이즈 L", isSoldOut: false, quantity: 1, isSelected: true),
        CartItem(id: "cart-2", title: "제품명", option: "사이즈 L", isSoldOut: false, quantity: 1, isSelected: true),
        CartItem(id: "cart-3", title: "제품명", option: "사이즈 L", isSoldOut: true, quantity: 1, isSelected: false)
    ]

    static let mixedPricingItems = [
        CartItem(id: "cart-priced-1", title: "제품명", option: "사이즈 L", isSoldOut: false, quantity: 1, isSelected: true),
        CartItem(id: "cart-priced-2", title: "제품명", option: "사이즈 L", isSoldOut: false, quantity: 1, isSelected: true),
        CartItem(id: "cart-quote-1", title: "제품명", option: "사이즈 L", isSoldOut: false, quantity: 1, isSelected: false, isQuoteProduct: true)
    ]

    static let zeroOrderItems = [
        CartItem(
            id: "cart-zero-quote-1",
            title: "제품명",
            option: "사이즈 L",
            isSoldOut: false,
            quantity: 1,
            isSelected: false,
            isQuoteProduct: true
        ),
        CartItem(
            id: "cart-zero-quote-2",
            title: "제품명",
            option: "사이즈 L",
            isSoldOut: false,
            quantity: 1,
            isSelected: false,
            isQuoteProduct: true
        )
    ]
}

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItem]

    init(items: [CartItem] = CartItem.mockItems) {
        self.items = items
    }

    var selectedCount: Int {
        items.filter(\.isSelected).count
    }

    var selectionItemCount: Int {
        items.filter { !$0.isQuoteProduct }.count
    }

    var quoteItemCount: Int {
        items.filter(\.isQuoteProduct).count
    }

    var allAvailableItemsSelected: Bool {
        let availableItems = items.filter { !$0.isSoldOut && !$0.isQuoteProduct }
        return !availableItems.isEmpty && availableItems.allSatisfy(\.isSelected)
    }

    func toggleSelection(itemID: String) {
        guard let index = items.firstIndex(where: { $0.id == itemID }),
              !items[index].isSoldOut,
              !items[index].isQuoteProduct else { return }
        items[index].isSelected.toggle()
    }

    func toggleSelectAll() {
        let shouldSelect = !allAvailableItemsSelected
        items = items.map { item in
            var updated = item
            if !updated.isSoldOut && !updated.isQuoteProduct { updated.isSelected = shouldSelect }
            return updated
        }
    }

    func removeSelected() {
        items.removeAll(where: \.isSelected)
    }

    func remove(itemID: String) {
        items.removeAll { $0.id == itemID }
    }

    func changeQuantity(itemID: String, by delta: Int) {
        guard let index = items.firstIndex(where: { $0.id == itemID }), !items[index].isSoldOut else { return }
        items[index].quantity = max(1, items[index].quantity + delta)
    }
}

struct CartView: View {
    enum Presentation: Equatable {
        case standard
        case mixedPricing
        case zeroOrder
    }

    @StateObject private var viewModel: CartViewModel
    @State private var presentedMessage: String?

    let cartCount: Int
    let presentation: Presentation
    let onSelectTab: (EUMTabBar.Tab) -> Void

    init(
        cartCount: Int,
        presentation: Presentation = .standard,
        onSelectTab: @escaping (EUMTabBar.Tab) -> Void
    ) {
        self.cartCount = cartCount
        self.presentation = presentation
        self.onSelectTab = onSelectTab
        let items: [CartItem]
        switch presentation {
        case .standard: items = CartItem.mockItems
        case .mixedPricing: items = CartItem.mixedPricingItems
        case .zeroOrder: items = CartItem.zeroOrderItems
        }
        _viewModel = StateObject(wrappedValue: CartViewModel(items: items))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            cartContent
            bottomArea
            EUMTabBar(
                selectedTab: .cart,
                cartCount: presentation == .zeroOrder ? viewModel.items.count : cartCount,
                onSelect: onSelectTab
            )
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

    private var topBar: some View {
        ZStack {
            Text("장바구니")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)

            HStack {
                Spacer()
                Button {
                    onSelectTab(.search)
                } label: {
                    Image("DesignSearch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("상품 검색")
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var cartContent: some View {
        ScrollView {
            VStack(spacing: presentation == .standard ? 16 : 0) {
                if presentation == .standard {
                    CartGuestNotice()
                        .padding(.horizontal, EUMSpacing.homeContentInset)
                        .padding(.top, 20)
                }
                selectionBar

                if presentation == .mixedPricing {
                    groupHeader(title: "주문 가능한 상품 (\(viewModel.selectionItemCount))")
                }

                VStack(spacing: 0) {
                    ForEach(orderedItems) { item in
                        CartItemRow(
                            item: item,
                            onToggleSelection: { viewModel.toggleSelection(itemID: item.id) },
                            onQuantityChange: { viewModel.changeQuantity(itemID: item.id, by: $0) },
                            onRemove: { viewModel.remove(itemID: item.id) },
                            onOptionChange: { presentedMessage = "옵션 변경은 상품 상세 화면에서 이용할 수 있어요." },
                            onQuoteRequest: { presentedMessage = "견적 문의는 로그인 후 이용할 수 있어요." }
                        )
                    }
                }

                if presentation != .standard {
                    CartQuoteGroupHeader(
                        count: viewModel.items.filter { $0.isQuoteProduct || $0.isSoldOut }.count,
                        onQuoteRequest: { presentedMessage = "견적 문의는 로그인 후 이용할 수 있어요." }
                    )
                    ForEach(viewModel.items.filter(\.isQuoteProduct)) { quoteItem in
                        CartItemRow(
                            item: quoteItem,
                            onToggleSelection: { viewModel.toggleSelection(itemID: quoteItem.id) },
                            onQuantityChange: { viewModel.changeQuantity(itemID: quoteItem.id, by: $0) },
                            onRemove: { viewModel.remove(itemID: quoteItem.id) },
                            onOptionChange: { presentedMessage = "옵션 변경은 상품 상세 화면에서 이용할 수 있어요." },
                            onQuoteRequest: { presentedMessage = "견적 문의는 로그인 후 이용할 수 있어요." }
                        )
                    }
                }

                if !viewModel.items.isEmpty {
                    priceSummary.padding(.top, presentation == .mixedPricing ? 16 : 0)
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var orderedItems: [CartItem] {
        viewModel.items.filter { !$0.isQuoteProduct }
    }

    private func groupHeader(title: String) -> some View {
        Text(title)
            .font(EUMTypography.labelLarge)
            .tracking(-0.16)
            .foregroundStyle(EUMColor.text1SwiftUI)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.top, 24)
            .padding(.bottom, 12)
    }

    private var selectionBar: some View {
        HStack(spacing: 8) {
            Button(action: viewModel.toggleSelectAll) {
                HStack(spacing: 8) {
                    CartCheckbox(
                        isSelected: viewModel.allAvailableItemsSelected,
                        isDisabled: viewModel.selectionItemCount == 0
                    )
                    Text("전체 선택 (\(viewModel.selectedCount)/\(viewModel.selectionItemCount))")
                        .font(EUMTypography.labelMedium)
                        .tracking(-0.07)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.selectionItemCount == 0)
            .accessibilityLabel("전체 선택, \(viewModel.selectedCount)개 선택됨")

            Spacer()

            Button("선택 삭제") {
                viewModel.removeSelected()
            }
            .font(EUMTypography.bodySmall)
            .tracking(-0.07)
            .foregroundStyle(EUMColor.text2SwiftUI)
            .buttonStyle(.plain)
            .disabled(viewModel.selectedCount == 0)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .frame(height: 56)
        .overlay(alignment: .bottom) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    private var priceSummary: some View {
        VStack(spacing: 12) {
            summaryRow(title: "상품금액", value: presentation == .zeroOrder ? "₩0" : "₩00,000")
            summaryRow(title: "배송비", value: "₩0")

            Rectangle()
                .fill(EUMColor.lineSwiftUI)
                .frame(height: 1)

            HStack {
                Text("결제예정금액")
                    .font(EUMTypography.labelLarge)
                    .tracking(-0.08)
                Spacer()
                Text(presentation == .zeroOrder ? "₩0" : "₩00,000")
                    .font(EUMTypography.heading2)
                    .tracking(-0.36)
            }
            .foregroundStyle(EUMColor.text1SwiftUI)
        }
        .padding(20)
        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.large))
        .overlay(RoundedRectangle(cornerRadius: EUMRadius.large).stroke(EUMColor.lineSwiftUI, lineWidth: 1))
        .padding(.horizontal, EUMSpacing.homeContentInset)
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text2SwiftUI)
            Spacer()
            Text(value)
                .font(EUMTypography.bodySmall)
                .tracking(-0.07)
                .foregroundStyle(EUMColor.text1SwiftUI)
        }
    }

    private var bottomArea: some View {
        VStack(spacing: 0) {
            if presentation == .mixedPricing {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14, weight: .medium))
                        .accessibilityHidden(true)
                    Text("가격 문의·품절 상품 \(viewModel.items.filter { $0.isQuoteProduct || $0.isSoldOut }.count)개는 주문에서 제외됩니다.")
                        .font(EUMTypography.captionMedium)
                        .tracking(-0.07)
                    Spacer(minLength: 0)
                }
                .foregroundStyle(EUMColor.text3SwiftUI)
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.vertical, 8)
                .background(EUMColor.surfaceSwiftUI)
            }
            EUMButton(title: bottomActionTitle, size: .large) {
                presentedMessage = presentation == .zeroOrder
                    ? "견적 문의는 로그인 후 이용할 수 있어요."
                    : "주문 기능은 로그인 및 결제 연동 후 이용할 수 있어요."
            }
            .disabled(presentation == .zeroOrder ? viewModel.quoteItemCount == 0 : viewModel.selectedCount == 0)
            .padding(.horizontal, EUMSpacing.homeContentInset)
            .padding(.vertical, 12)
        }
        .background(EUMColor.backgroundSwiftUI)
        .overlay(alignment: .top) {
            Rectangle().fill(EUMColor.lineSwiftUI).frame(height: 1)
        }
    }

    private var bottomActionTitle: String {
        if presentation == .zeroOrder {
            return "담은 상품으로 견적 문의 (\(viewModel.quoteItemCount))"
        }
        return "₩00,000 주문하기 (\(viewModel.selectedCount))"
    }
}
