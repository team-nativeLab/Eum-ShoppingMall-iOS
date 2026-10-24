import SwiftUI

struct HomeModalRouteHostView: View {
    let route: HomeModalRoute
    @ObservedObject var addressViewModel: AddressesViewModel
    @ObservedObject var contactInquiryViewModel: ContactInquiryHistoryViewModel
    @ObservedObject var withdrawalNoticeViewModel: AccountWithdrawalNoticeViewModel
    let isGuestAccount: Bool
    let activeWithdrawalOrderCount: Int
    let onBack: () -> Void
    let onSearch: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onBrowseProducts: () -> Void
    let onAddressChange: (OrderHistoryItem) -> Void
    let onViewContactInquiries: () -> Void
    let onHome: () -> Void
    let onWithdrawal: () -> Void
    let onLogout: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .authentication:
            AuthenticationFlowView(onClose: onBack)
        case .settingsLogin:
            AuthenticationFlowView(onClose: onBack)
        case .quoteInquiry, .accountCollection:
            HomeAccountRouteView(
                route: route,
                addressViewModel: addressViewModel,
                contactInquiryViewModel: contactInquiryViewModel,
                onBack: onBack,
                onHome: onHome,
                onRoute: onRoute,
                onMessage: onMessage,
                onProductTap: onProductTap,
                onBrowseProducts: onBrowseProducts,
                onWithdrawTap: onWithdrawal
            )
        case .orderHistory, .orderDetail, .deliveryTracking, .returnRequest, .returnHistory, .quoteDetail:
            HomeOrderRouteView(
                route: route,
                onBack: onBack,
                onRoute: onRoute,
                onMessage: onMessage,
                onBrowseProducts: onBrowseProducts,
                onAddressChange: onAddressChange
            )
        case .returnHub, .returnOrderSelection, .returnRejectionReason, .returnRequestDetail, .returnWithdrawalConfirmation:
            HomeReturnRequestRouteView(route: route, onBack: onBack, onRoute: onRoute, onMessage: onMessage)
        case .accountVerification, .companyIntroduction:
            HomeProfileRouteView(
                route: route,
                onBack: onBack,
                onRoute: onRoute,
                onMessage: onMessage
            )
        case .customerCenter, .announcements, .announcementDetail, .events, .eventDetail:
            HomeSupportRouteView(route: route, onBack: onBack, onRoute: onRoute, onMessage: onMessage)
        case .inquiryCompose, .inquiryComplete, .productReviews, .productReviewRegistration:
            HomeInquiryRouteView(
                route: route,
                contactInquiryViewModel: contactInquiryViewModel,
                onBack: onBack,
                onSearch: onSearch,
                onRoute: onRoute,
                onViewInquiries: onViewContactInquiries
            )
        case let .shippingPolicy(product):
            ProductShippingPolicyView(product: product, onBack: onBack)
        case .settings, .terms, .privacyPolicy, .usageGuide, .openSourceLicenses:
            HomeLegalRouteContainer(
                route: route,
                isGuestAccount: isGuestAccount,
                back: onBack,
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
                onBack: onBack,
                onHome: onHome
            )
        case let .addressEditor(address):
            AddressEditorRouteView(
                address: address,
                onBack: onBack,
                onSave: { addressViewModel.save($0); onBack() }
            )
        }
    }
}
