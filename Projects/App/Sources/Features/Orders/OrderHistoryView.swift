import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel = OrderHistoryViewModel()

    let onBack: () -> Void
    let onCancelReturn: () -> Void
    let onOrderDetail: (OrderHistoryItem) -> Void
    let onCancelOrder: (OrderHistoryItem) -> Void
    let onTrackDelivery: (OrderHistoryItem) -> Void
    let onReorder: (OrderHistoryItem) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("주문내역")
                .font(EUMTypography.labelLarge)
                .tracking(-0.16)
                .foregroundStyle(EUMColor.text1SwiftUI)
            HStack(spacing: 0) {
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
                Button("취소·반품", action: onCancelReturn)
                    .font(EUMTypography.labelMedium)
                    .foregroundStyle(EUMColor.text1SwiftUI)
                    .padding(.horizontal, 12)
                    .frame(height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
    }

    private var filters: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(OrderHistoryStatus.allCases) { status in
                    OrderHistoryFilterChip(status: status, isSelected: status == viewModel.selectedStatus) {
                        viewModel.selectStatus(status)
                    }
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
            Text("해당 상태의 주문이 없습니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, minHeight: 180)
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
}

struct OrderHistoryViewPreview: PreviewProvider {
    static var previews: some View {
        OrderHistoryView(
            onBack: {},
            onCancelReturn: {},
            onOrderDetail: { _ in },
            onCancelOrder: { _ in },
            onTrackDelivery: { _ in },
            onReorder: { _ in }
        )
    }
}
