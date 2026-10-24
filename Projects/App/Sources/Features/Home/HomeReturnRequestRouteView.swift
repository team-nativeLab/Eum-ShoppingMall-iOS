import SwiftUI

struct HomeReturnRequestRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void

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
                    onBack()
                    onMessage("신청 철회는 서버 연동 후 반영됩니다.")
                }
            )
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}
