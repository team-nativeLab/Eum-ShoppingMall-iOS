import SwiftUI

struct ReturnHubView: View {
    let onBack: () -> Void
    let onOrders: () -> Void
    let onHistory: () -> Void
    let onApply: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(title: "취소·반품·교환", backAccessibilityLabel: "이전 화면으로 돌아가기", onBack: onBack) {
                EmptyView()
            }
            ScrollView {
                VStack(spacing: 16) {
                    entry("주문/배송 조회", message: "주문 상태와 배송 정보를 확인해요", action: onOrders)
                    entry("취소/반품 내역", message: "신청 상태와 처리 내역을 확인해요", action: onHistory)
                    entry("취소/반품/교환 신청", message: "신청할 주문을 선택해 주세요", action: onApply)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
    }

    private func entry(_ title: String, message: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("NotoSansKR-Bold", size: 16))
                    .foregroundStyle(Color(red: 26 / 255, green: 33 / 255, blue: 31 / 255))
                Text(message)
                    .font(.custom("NotoSansKR-Regular", size: 13))
                    .foregroundStyle(Color(red: 89 / 255, green: 102 / 255, blue: 97 / 255))
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(16)
            .background(Color(red: 245 / 255, green: 247 / 255, blue: 245 / 255),
                        in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

struct ReturnOrderSelectionView: View {
    @StateObject private var viewModel = OrderHistoryViewModel()
    let onBack: () -> Void
    let onDetail: (OrderHistoryItem) -> Void
    let onTrack: (OrderHistoryItem) -> Void
    let onSelect: (OrderHistoryItem) -> Void

    var body: some View {
        VStack(spacing: 0) {
            EUMBackTopBar(
                title: "신청할 주문 선택",
                backAccessibilityLabel: "이전 화면으로 돌아가기",
                backAccessibilityIdentifier: "return-order-select-back",
                onBack: onBack
            ) {
                EmptyView()
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(OrderHistoryStatus.allCases) { status in
                                OrderHistoryFilterChip(status: status, isSelected: viewModel.selectedStatus == status) {
                                    viewModel.selectStatus(status)
                                }
                                .accessibilityIdentifier("return-select-filter-\(status.id)")
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    Text("주문을 선택하면 신청 가능한 항목을 확인할 수 있어요.")
                        .font(EUMTypography.captionRegular)
                        .foregroundStyle(EUMColor.text2SwiftUI)
                        .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                        .padding(12)
                        .background(EUMColor.backgroundSubtleSwiftUI, in: RoundedRectangle(cornerRadius: 8))
                    Menu {
                        ForEach(OrderHistoryPeriod.allCases) { period in
                            Button(period.rawValue) { viewModel.selectPeriod(period) }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(viewModel.selectedPeriod.rawValue)
                            Image("ProductOptionChevron").resizable().frame(width: 16, height: 16)
                        }
                        .font(EUMTypography.labelMedium)
                        .foregroundStyle(EUMColor.text1SwiftUI)
                    }
                    if viewModel.filteredOrders.isEmpty {
                        AccountEmptyState(title: "주문 내역이 없습니다", message: "조회 조건을 변경해 주세요.")
                    }
                    ForEach(viewModel.filteredOrders) { order in
                        OrderHistoryOrderCard(
                            order: order, onDetail: { onDetail(order) }, onCancel: {},
                            onTrack: { onTrack(order) }, onReorder: {}, selectionAction: { onSelect(order) }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
        }
        .background(AccountEmptyState.background.ignoresSafeArea())
    }
}
