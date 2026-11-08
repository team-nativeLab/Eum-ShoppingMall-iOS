import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel: OrderHistoryViewModel

    let onBack: () -> Void
    let onCancelReturn: () -> Void
    let onBrowseProducts: () -> Void
    let onOrderDetail: (OrderHistoryItem) -> Void
    let onCancelOrder: (OrderHistoryItem) -> Void
    let onTrackDelivery: (OrderHistoryItem) -> Void
    let onReorder: (OrderHistoryItem) -> Void

    init(
        orders: [OrderHistoryItem] = OrderHistoryItem.samples,
        initialStatus: OrderHistoryStatus = .all,
        onBack: @escaping () -> Void,
        onCancelReturn: @escaping () -> Void,
        onBrowseProducts: @escaping () -> Void = {},
        onOrderDetail: @escaping (OrderHistoryItem) -> Void,
        onCancelOrder: @escaping (OrderHistoryItem) -> Void,
        onTrackDelivery: @escaping (OrderHistoryItem) -> Void,
        onReorder: @escaping (OrderHistoryItem) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: OrderHistoryViewModel(orders: orders, initialStatus: initialStatus))
        self.onBack = onBack
        self.onCancelReturn = onCancelReturn
        self.onBrowseProducts = onBrowseProducts
        self.onOrderDetail = onOrderDetail
        self.onCancelOrder = onCancelOrder
        self.onTrackDelivery = onTrackDelivery
        self.onReorder = onReorder
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            if viewModel.orders.isEmpty {
                emptyOrderHistory
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        filters
                        periodMenu
                        orderList
                    }
                    .padding(.horizontal, EUMSpacing.homeContentInset)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
        }
        .background((viewModel.orders.isEmpty ? AccountEmptyState.background : EUMColor.backgroundSwiftUI).ignoresSafeArea())
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "주문내역",
            backAccessibilityLabel: "이전 화면으로 돌아가기",
            contentSpacing: 0,
            onBack: onBack
        ) {
            Button("취소·반품", action: onCancelReturn)
                .font(EUMTypography.labelMedium)
                .foregroundStyle(EUMColor.text1SwiftUI)
                .padding(.horizontal, 12)
                .frame(height: 44)
        }
    }

    private var filters: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(OrderHistoryStatus.allCases) { status in
                    OrderHistoryFilterChip(status: status, isSelected: status == viewModel.selectedStatus) {
                        viewModel.selectStatus(status)
                    }
                    .accessibilityIdentifier("order-history-filter-\(status.id)")
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.trailing, -EUMSpacing.homeContentInset)
    }

    private var periodMenu: some View {
        Menu {
            ForEach(OrderHistoryPeriod.allCases) { period in
                Button(period.rawValue) {
                    viewModel.selectPeriod(period)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.selectedPeriod.rawValue)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(EUMColor.text1SwiftUI)
            }
            .frame(height: 20)
        }
        .accessibilityLabel("조회 기간, \(viewModel.selectedPeriod.rawValue)")
    }

    @ViewBuilder
    private var orderList: some View {
        if viewModel.filteredOrders.isEmpty {
            VStack(spacing: 12) {
                emptyState
                browseProductsButton
            }
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.filteredOrders) { order in
                    OrderHistoryOrderCard(
                        order: order,
                        onDetail: { onOrderDetail(order) },
                        onCancel: { onCancelOrder(order) },
                        onTrack: { onTrackDelivery(order) },
                        onReorder: { onReorder(order) }
                    )
                }
            }
        }
    }

    private var emptyOrderHistory: some View {
        VStack(spacing: 12) {
            Spacer(minLength: 0)
            emptyState
            browseProductsButton
            Spacer(minLength: 0)
        }
        .padding(.horizontal, EUMSpacing.homeContentInset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyState: some View {
        AccountEmptyState(
            title: "주문 내역이 없습니다", message: "상품을 주문하면 이곳에서\n주문·배송 상태를 확인할 수 있어요."
        )
        .accessibilityIdentifier("order-history-empty-state")
    }

    private var browseProductsButton: some View {
        Button(action: onBrowseProducts) {
            Text("상품 둘러보기")
                .font(.custom("NotoSansKR-Bold", size: 14))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color(red: 20 / 255, green: 26 / 255, blue: 23 / 255),
                            in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("order-history-browse-products")
    }
}

struct OrderHistoryViewPreview: PreviewProvider {
    static var previews: some View {
        OrderHistoryView(
            onBack: {},
            onCancelReturn: {},
            onBrowseProducts: {},
            onOrderDetail: { _ in },
            onCancelOrder: { _ in },
            onTrackDelivery: { _ in },
            onReorder: { _ in }
        )
    }
}
