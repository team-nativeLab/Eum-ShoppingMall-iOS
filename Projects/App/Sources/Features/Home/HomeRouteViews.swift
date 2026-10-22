import SwiftUI

struct HomeAccountTabView: View {
    let cartCount: Int
    let isGuestAccount: Bool
    let onSelectTab: (EUMTabBar.Tab) -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onProductTap: (HomeProduct) -> Void

    @ViewBuilder
    var body: some View {
        if isGuestAccount {
            GuestMyPageView(
                onCustomerCenterTap: { onRoute(.customerCenter) },
                onAnnouncementsTap: { onRoute(.announcements) },
                cartCount: cartCount,
                onLoginTap: { onRoute(.authentication) },
                onSettingsTap: { onRoute(.settings) },
                onProductTap: onProductTap,
                onSelectTab: onSelectTab
            )
        } else {
            MyPageView(
                onCustomerCenterTap: { onRoute(.customerCenter) },
                onAnnouncementsTap: { onRoute(.announcements) },
                cartCount: cartCount,
                onSelectTab: onSelectTab,
                onOrderStatusTap: { onRoute(.orderHistory(status: $0)) },
                onOrderHistoryTap: { onRoute(.orderHistory()) },
                onFavoritesTap: { onRoute(.accountCollection(.favorites)) },
                onRecentlyViewedTap: { onRoute(.accountCollection(.recentlyViewed)) },
                onCouponsTap: { onRoute(.accountCollection(.coupons)) },
                onPointsTap: { onRoute(.accountCollection(.points)) },
                onAddressesTap: { onRoute(.accountCollection(.addresses)) },
                onQuoteHistoryTap: { onRoute(.accountCollection(.quoteHistory)) },
                onContactHistoryTap: { onRoute(.accountCollection(.contactHistory)) },
                onReturnsHistoryTap: { onRoute(.returnHistory) },
                onAccountVerificationTap: { onRoute(.accountVerification) },
                onSettingsTap: { onRoute(.settings) }
            )
        }
    }
}

struct HomeAccountRouteView: View {
    let route: HomeModalRoute
    @ObservedObject var addressViewModel: AddressesViewModel
    @ObservedObject var contactInquiryViewModel: ContactInquiryHistoryViewModel
    let onBack: () -> Void
    let onHome: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onWithdrawTap: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case let .quoteInquiry(product):
            QuoteInquiryView(
                product: product,
                onBack: onBack,
                onContinueShopping: onHome,
                onViewInquiries: { onRoute(.accountCollection(.quoteHistory)) }
            )
        case let .accountCollection(destination):
            HomeAccountCollectionRouteView(
                destination: destination,
                addressViewModel: addressViewModel,
                contactInquiryViewModel: contactInquiryViewModel,
                onBack: onBack,
                onRoute: onRoute,
                onMessage: onMessage,
                onProductTap: onProductTap,
                onWithdrawTap: onWithdrawTap
            )
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}

struct HomeProfileRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .accountVerification:
            AccountVerificationRouteView(
                onBack: onBack,
                onVerified: { onRoute(.accountCollection(.editProfile)) },
                onMessage: onMessage
            )
        case .companyIntroduction:
            CompanyIntroductionView(
                onBack: onBack,
                onOpenMap: { onMessage("주소가 임시 정보라 지도 앱과 연결되지 않았어요.") }
            )
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}

struct HomeAccountCollectionRouteView: View {
    let destination: AccountCollectionDestination
    @ObservedObject var addressViewModel: AddressesViewModel
    @ObservedObject var contactInquiryViewModel: ContactInquiryHistoryViewModel
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onWithdrawTap: () -> Void

    var body: some View {
        AccountCollectionRouteView(
            destination: destination,
            addressViewModel: addressViewModel,
            contactInquiryViewModel: contactInquiryViewModel,
            onBack: onBack,
            onRoute: onRoute,
            onOpenNotification: { onRoute(.destination(for: $0)) },
            onPointsTap: { onRoute(.accountCollection(.points)) },
            onAddAddress: { onRoute(.addressEditor(nil)) },
            onEditAddress: { onRoute(.addressEditor($0)) },
            onAction: onMessage,
            onProductTap: onProductTap,
            onNewQuoteInquiry: { onRoute(.quoteInquiry(nil)) },
            onQuoteDocument: { onRoute(.quoteDetail($0)) },
            onOpenQuoteDetail: { onRoute(.quoteDetail($0)) },
            onOpenContactInquiryDetail: { onRoute(.accountCollection(.contactDetail($0))) },
            onWithdrawTap: onWithdrawTap
        )
    }
}

struct HomeOrderRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void
    let onBrowseProducts: () -> Void
    let onAddressChange: (OrderHistoryItem) -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case let .orderHistory(status):
            OrderHistoryView(
                initialStatus: status,
                onBack: onBack,
                onCancelReturn: { onRoute(.returnHistory) },
                onBrowseProducts: onBrowseProducts,
                onOrderDetail: { onRoute(.orderDetail($0)) },
                onCancelOrder: { _ in onMessage("주문 취소는 서버 연동 후 이용할 수 있어요.") },
                onTrackDelivery: { onRoute(.deliveryTracking($0)) },
                onReorder: { _ in onMessage("다시 담기는 장바구니 연결 후 이용할 수 있어요.") }
            )
        case let .orderDetail(order):
            OrderDetailView(
                order: order,
                onBack: onBack,
                onTrackDelivery: { onRoute(.deliveryTracking(order)) },
                onReturnExchange: { onRoute(.returnRequest(order)) },
                onDocumentDownload: { onMessage("거래명세서는 주문 서비스 연동 후 다운로드할 수 있어요.") },
                onReceipt: { onMessage("영수증은 주문 서비스 연동 후 확인할 수 있어요.") }
            )
        case let .deliveryTracking(order):
            DeliveryTrackingView(order: order, onBack: onBack)
        case let .returnRequest(order):
            ReturnRequestView(
                order: order,
                onBack: onBack,
                onAddressChange: { onAddressChange(order) },
                onSubmit: onMessage
            )
        case .returnHistory:
            ReturnHistoryView(
                onBack: onBack,
                onDetail: { onRoute(.returnRequestDetail($0)) },
                onWithdraw: { onRoute(.returnWithdrawalConfirmation($0)) },
                onRejectionReason: { item in onMessage(item.rejectionReason ?? "반려 사유가 없습니다.") }
            )
        case let .quoteDetail(inquiry):
            QuoteDetailView(
                inquiry: inquiry,
                onBack: onBack,
                onDownload: { fileName in onMessage("\(fileName)은 서비스 연동 후 다운로드할 수 있어요.") },
                onContact: { onMessage("담당자 연락은 서비스 연동 후 이용할 수 있어요.") },
                onRequote: { onRoute(.quoteInquiry(nil)) }
            )
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}

struct AccountCollectionRouteView: View {
    let destination: AccountCollectionDestination
    @ObservedObject var addressViewModel: AddressesViewModel
    @ObservedObject var contactInquiryViewModel: ContactInquiryHistoryViewModel
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onOpenNotification: (NotificationKind) -> Void
    let onPointsTap: () -> Void
    let onAddAddress: () -> Void
    let onEditAddress: (ShippingAddress) -> Void
    let onAction: (String) -> Void
    let onProductTap: (HomeProduct) -> Void
    let onNewQuoteInquiry: () -> Void
    let onQuoteDocument: (QuoteInquiryRecord) -> Void
    let onOpenQuoteDetail: (QuoteInquiryRecord) -> Void
    let onOpenContactInquiryDetail: (ContactInquiryRecord) -> Void
    let onWithdrawTap: () -> Void

    @ViewBuilder
    var body: some View {
        switch destination {
        case .favorites:
            FavoritesView(onBack: onBack, onProductTap: onProductTap)
        case .recentlyViewed:
            RecentlyViewedView(onBack: onBack, onProductTap: onProductTap)
        case .coupons:
            CouponsView(onBack: onBack, onPointsTap: onPointsTap)
        case .points:
            PointsView(onBack: onBack)
        case .editProfile:
            ProfileEditView(onBack: onBack, onAction: onAction, onWithdrawTap: onWithdrawTap)
        case .addresses:
            AddressesView(viewModel: addressViewModel, onBack: onBack, onAdd: onAddAddress, onEdit: onEditAddress)
        case .quoteHistory:
            QuoteHistoryView(
                onBack: onBack,
                onNewInquiry: onNewQuoteInquiry,
                onDocument: onQuoteDocument,
                onOpenDetail: onOpenQuoteDetail
            )
        case .contactHistory:
            ContactInquiryHistoryView(
                viewModel: contactInquiryViewModel,
                onBack: onBack,
                onNewInquiry: { onRoute(.inquiryCompose(.contact)) },
                onOpenDetail: onOpenContactInquiryDetail
            )
        case let .contactDetail(inquiry):
            ContactInquiryDetailView(
                inquiry: inquiry,
                onBack: onBack,
                onDownload: { fileName in onAction("\(fileName)은 파일 서비스 연동 후 다운로드할 수 있어요.") }
            )
        case .notifications:
            NotificationsView(onBack: onBack, onOpenNotification: onOpenNotification)
        }
    }
}

struct AccountVerificationRouteView: View {
    let onBack: () -> Void
    let onVerified: () -> Void
    let onMessage: (String) -> Void

    var body: some View {
        AccountVerificationView(onBack: onBack) { message in
            if let message {
                onMessage(message)
            } else {
                onVerified()
            }
        }
    }
}

struct AddressEditorRouteView: View {
    @State private var presentedMessage: String?

    let address: ShippingAddress?
    let onBack: () -> Void
    let onSave: (ShippingAddress) -> Void

    var body: some View {
        AddressEditorView(
            address: address,
            onBack: onBack,
            onSave: onSave,
            onUnavailableAction: { presentedMessage = $0 }
        )
        .alert("안내", isPresented: messagePresented) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
    }

    private var messagePresented: Binding<Bool> {
        Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )
    }
}

struct HomeSupportRouteView: View {
    let route: HomeModalRoute
    let onBack: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onMessage: (String) -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .customerCenter:
            CustomerCenterView(
                onBack: onBack,
                onCall: { onMessage("고객센터 전화 연결은 번호 연동 후 이용할 수 있어요.") },
                onContact: { onRoute(.accountCollection(.contactHistory)) }
            )
        case .announcements:
            AnnouncementsView(
                onBack: onBack,
                onOpenAnnouncement: { onRoute(.announcementDetail($0)) }
            )
        case let .announcementDetail(announcement):
            AnnouncementDetailView(
                announcement: announcement,
                onBack: onBack,
                onDownload: { onMessage("\($0)은 파일 서비스 연동 후 다운로드할 수 있어요.") }
            )
        case .events:
            EventsView(onBack: onBack, onOpenEvent: { onRoute(.eventDetail($0)) })
        case let .eventDetail(event):
            EventDetailView(event: event, onBack: onBack)
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}

struct HomeWithdrawalRouteView: View {
    let route: HomeModalRoute
    @ObservedObject var noticeViewModel: AccountWithdrawalNoticeViewModel
    let activeOrderCount: Int
    let onRoute: (HomeModalRoute) -> Void
    let onBack: () -> Void
    let onHome: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case .accountWithdrawalNotice:
            AccountWithdrawalNoticeView(
                viewModel: noticeViewModel,
                onBack: onBack,
                onContinue: { onRoute(.accountWithdrawalReason) }
            )
        case .accountWithdrawalBlocked:
            AccountWithdrawalBlockedView(
                viewModel: AccountWithdrawalBlockedViewModel(activeOrderCount: activeOrderCount),
                onBack: onBack,
                onOrderHistory: { onRoute(.orderHistory()) }
            )
        case .accountWithdrawalReason:
            AccountWithdrawalReasonView(
                onBack: onBack,
                onSubmit: { onRoute(.accountWithdrawalComplete) }
            )
        case .accountWithdrawalComplete:
            AccountWithdrawalCompleteView(onHome: onHome)
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}

struct HomeLoadErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("홈 정보를 불러오지 못했어요.")
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
            EUMButton(title: "다시 시도", kind: .secondary, action: onRetry)
                .frame(maxWidth: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
