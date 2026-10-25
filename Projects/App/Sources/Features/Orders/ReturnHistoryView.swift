import SwiftUI

struct ReturnHistoryView: View {
    @ObservedObject var viewModel: ReturnHistoryViewModel

    let onBack: () -> Void
    let onDetail: (ReturnHistoryItem) -> Void
    let onWithdraw: (ReturnHistoryItem) -> Void
    let onRejectionReason: (ReturnHistoryItem) -> Void
    let onOrders: () -> Void

    init(
        viewModel: ReturnHistoryViewModel,
        onBack: @escaping () -> Void,
        onDetail: @escaping (ReturnHistoryItem) -> Void,
        onWithdraw: @escaping (ReturnHistoryItem) -> Void,
        onRejectionReason: @escaping (ReturnHistoryItem) -> Void,
        onOrders: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onBack = onBack
        self.onDetail = onDetail
        self.onWithdraw = onWithdraw
        self.onRejectionReason = onRejectionReason
        self.onOrders = onOrders
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            if viewModel.items.isEmpty {
                emptyState.padding(20).frame(maxHeight: .infinity)
            } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    filters
                    itemList
                }
                .padding(.horizontal, EUMSpacing.homeContentInset)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            }
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
    }

    private var topBar: some View {
        EUMBackTopBar(
            title: "취소/반품/교환 내역",
            backAccessibilityLabel: "이전 화면으로 돌아가기",
            onBack: onBack
        ) {
            Color.clear.frame(width: 44, height: 44)
        }
    }

    private var filters: some View {
        HStack(spacing: 8) {
            ForEach(ReturnHistoryFilter.allCases) { filter in
                ReturnHistoryFilterChip(filter: filter, isSelected: filter == viewModel.selectedFilter) {
                    viewModel.select(filter)
                }
            }
        }
    }

    private var emptyState: some View {
        AccountEmptyState(
            title: "신청 내역이 없습니다", message: "취소·반품·교환을 신청하면\n처리 상태를 확인할 수 있어요.",
            actionTitle: "주문/배송 조회", actionIdentifier: "return-empty-orders", onAction: onOrders
        )
    }

    @ViewBuilder
    private var itemList: some View {
        if viewModel.filteredItems.isEmpty {
            emptyState
        } else {
            VStack(spacing: 12) {
                ForEach(viewModel.filteredItems) { item in
                    ReturnHistoryCard(
                        item: item,
                        onDetail: { onDetail(item) },
                        onWithdraw: { onWithdraw(item) },
                        onRejectionReason: { onRejectionReason(item) }
                    )
                }
            }
        }
    }
}

struct ReturnHistoryViewPreview: PreviewProvider {
    static var previews: some View {
        ReturnHistoryView(
            viewModel: ReturnHistoryViewModel(),
            onBack: {},
            onDetail: { _ in },
            onWithdraw: { _ in },
            onRejectionReason: { _ in },
            onOrders: {}
        )
    }
}
