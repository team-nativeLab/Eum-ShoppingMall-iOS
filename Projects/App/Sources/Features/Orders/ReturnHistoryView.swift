import SwiftUI

struct ReturnHistoryView: View {
    @StateObject private var viewModel = ReturnHistoryViewModel()

    let onBack: () -> Void
    let onDetail: (ReturnHistoryItem) -> Void
    let onWithdraw: (ReturnHistoryItem) -> Void
    let onRejectionReason: (ReturnHistoryItem) -> Void

    var body: some View {
        VStack(spacing: 0) {
            topBar
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
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
    }

    private var topBar: some View {
        ZStack {
            Text("취소/반품/교환 내역")
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
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
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

    @ViewBuilder
    private var itemList: some View {
        if viewModel.filteredItems.isEmpty {
            Text("해당 신청 내역이 없습니다.")
                .font(EUMTypography.bodySmall)
                .foregroundStyle(EUMColor.text3SwiftUI)
                .frame(maxWidth: .infinity, minHeight: 180)
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
        ReturnHistoryView(onBack: {}, onDetail: { _ in }, onWithdraw: { _ in }, onRejectionReason: { _ in })
    }
}
