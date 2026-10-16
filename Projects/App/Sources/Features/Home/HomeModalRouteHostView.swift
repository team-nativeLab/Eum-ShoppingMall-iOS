import SwiftUI

struct HomeModalRouteHostView: View {
    let route: HomeModalRoute
    @ObservedObject var addressViewModel: AddressesViewModel
    @ObservedObject var withdrawalNoticeViewModel: AccountWithdrawalNoticeViewModel
    let isGuestAccount: Bool
    let activeWithdrawalOrderCount: Int
    let onBack: (HomeModalRoute) -> Void
    let onBackToDrawer: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onAddressChange: (OrderHistoryItem) -> Void
    let onHome: () -> Void
    let onWithdrawal: () -> Void
    let onLogout: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .authentication:
            AuthenticationFlowView(onClose: { onBack(route) })
        case .settingsLogin:
            AuthenticationFlowView(onClose: { onRoute(.settings) })
        case .quoteInquiry, .accountCollection:
            HomeAccountRouteView(
                route: route,
                addressViewModel: addressViewModel,
                onBack: { onBack(route) },
                onRoute: onRoute,
                onMessage: onMessage,
                onProductTap: onProductTap,
                onWithdrawTap: onWithdrawal
            )
        case .orderHistory, .orderDetail, .deliveryTracking, .returnRequest, .returnHistory, .quoteDetail:
            HomeOrderRouteView(
                route: route,
                onBack: { onBack(route) },
                onRoute: onRoute,
                onMessage: onMessage,
                onAddressChange: onAddressChange
            )
        case .accountVerification, .companyIntroduction:
            HomeProfileRouteView(
                route: route,
                onBack: { onBack(route) },
                onBackToDrawer: onBackToDrawer,
                onRoute: onRoute,
                onMessage: onMessage
            )
        case .customerCenter, .announcements, .announcementDetail:
            HomeSupportRouteView(route: route, onBack: { onBack(route) }, onRoute: onRoute, onMessage: onMessage)
        case .settings, .terms, .termsPrevious, .privacyPolicy, .usageGuide:
            HomeLegalRouteContainer(
                route: route,
                isGuestAccount: isGuestAccount,
                back: { onBack(route) },
                backToSettings: { onRoute(.settings) },
                login: { onRoute(.settingsLogin) },
                onRoute: onRoute,
                message: onMessage,
                logout: onLogout,
                withdrawal: onWithdrawal
            )
        case .accountWithdrawalNotice, .accountWithdrawalBlocked, .accountWithdrawalReason, .accountWithdrawalComplete:
            HomeWithdrawalRouteView(
                route: route,
                noticeViewModel: withdrawalNoticeViewModel,
                activeOrderCount: activeWithdrawalOrderCount,
                onRoute: onRoute,
                onHome: onHome
            )
        case let .addressEditor(address):
            AddressEditorRouteView(
                address: address,
                onBack: { onRoute(.accountCollection(.addresses)) },
                onSave: { addressViewModel.save($0); onRoute(.accountCollection(.addresses)) }
            )
        }
    }
}
