import SwiftUI

struct HomeReturnRequestRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onConfirmWithdraw: (ReturnHistoryItem) -> Void
    let onViewHistory: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .returnHub:
            ReturnHubView(
                onBack: onBack, onOrders: { onRoute(.orderHistory()) },
                onHistory: { onRoute(.returnHistory) }, onApply: { onRoute(.returnOrderSelection) }
            )
        case .returnOrderSelection:
            ReturnOrderSelectionView(
                onBack: onBack, onDetail: { onRoute(.orderDetail($0)) },
                onTrack: { onRoute(.deliveryTracking($0)) }, onSelect: { onRoute(.returnRequest($0)) }
            )
        case let .returnRejectionReason(item):
            ReturnRejectionReasonView(item: item, onBack: onBack)
        case let .returnRequestComplete(item):
            ReturnRequestCompletionView(item: item, onBack: onBack, onViewHistory: onViewHistory)
        case let .returnWithdrawalComplete(item):
            ReturnWithdrawalCompletionView(item: item, onViewHistory: onViewHistory)
        case let .returnRequestDetail(item):
            ReturnRequestDetailView(
                item: item,
                onBack: onBack,
                onWithdraw: { onRoute(.returnWithdrawalConfirmation(item)) }
            )
        case let .returnWithdrawalConfirmation(item):
            ReturnWithdrawalConfirmationView(
                item: item,
                onCancel: onBack,
                onConfirm: {
                    #if DEBUG
                    onConfirmWithdraw(item)
                    #else
                    onMessage("신청 철회는 서버 연동 후 반영됩니다.")
                    #endif
                }
            )
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}
