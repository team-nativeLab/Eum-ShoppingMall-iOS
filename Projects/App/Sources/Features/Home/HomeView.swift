import SwiftUI

enum HomeModalRoute {
    case authentication
    case settingsLogin
    case quoteInquiry(HomeProduct?)
    case quoteDetail(QuoteInquiryRecord)
    case accountCollection(AccountCollectionDestination)
    case orderHistory
    case orderDetail(OrderHistoryItem)
    case deliveryTracking(OrderHistoryItem)
    case returnRequest(OrderHistoryItem)
    case returnHistory(backToOrderHistory: Bool)
    case accountVerification
    case settings
    case terms
    case termsPrevious
    case privacyPolicy
    case addressEditor(ShippingAddress?)
    case accountWithdrawalNotice
    case accountWithdrawalBlocked
    case accountWithdrawalReason
    case accountWithdrawalComplete
}

enum AccountCollectionDestination {
    case favorites
    case recentlyViewed
    case coupons
    case points
    case editProfile
    case addresses
    case quoteHistory
    case contactHistory
    case contactDetail(ContactInquiryRecord)
    case notifications
}

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @StateObject private var addressesViewModel = AddressesViewModel()
    @StateObject private var withdrawalNoticeViewModel = AccountWithdrawalNoticeViewModel()
    @State private var searchText = ""
    @State private var selectedTab = EUMTabBar.Tab.home
    @State private var searchReturnTab = EUMTabBar.Tab.home
    @State private var selectedProductCategory: HomeCategory?
    @State private var selectedProduct: HomeProduct?
    @State private var presentedRoute: HomeModalRoute?
    @State private var isShowingDrawer = false
    @State private var isGuestAccount = false
    @State private var isShowingCheckoutAddress = false
    @State private var isShowingCheckoutPayment = false
    @State private var isShowingCheckoutComplete = false
    @State private var completedPaymentMethod: CheckoutPaymentMethod = .creditCard
    @State private var presentedMessage: String?

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case let .content(content):
                contentView(content)
            case .failed:
                loadError
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .overlay {
            if isShowingDrawer {
                AppDrawerView(
                    onDismiss: { withAnimation(.easeOut(duration: 0.2)) { isShowingDrawer = false } },
                    onMyInfo: {
                        isShowingDrawer = false
                        isGuestAccount = false
                        selectedTab = .account
                    },
                    onDestination: { destination in
                        isShowingDrawer = false
                        if destination == "맞춤 제작·견적 문의" {
                            presentedRoute = .quoteInquiry(nil)
                        } else {
                            presentedMessage = "\(destination) 화면은 아직 연결되지 않았어요."
                        }
                    },
                    onSettings: {
                        isShowingDrawer = false
                        presentedRoute = .settings
                    },
                    onLogout: {
                        isShowingDrawer = false
                        isGuestAccount = true
                        selectedTab = .account
                    }
                )
                .zIndex(1)
            }
        }
        .alert("안내", isPresented: Binding(
            get: { presentedMessage != nil },
            set: { if !$0 { presentedMessage = nil } }
        )) {
            Button("확인", role: .cancel) { presentedMessage = nil }
        } message: {
            Text(presentedMessage ?? "")
        }
        .task {
            if case .loading = viewModel.state {
                await viewModel.load()
            }
        }
    }

    @ViewBuilder
    private func contentView(_ content: HomeContent) -> some View {
        if let presentedRoute {
            routeView(presentedRoute)
        } else if isShowingCheckoutComplete {
            CheckoutCompleteView(
                paymentMethod: completedPaymentMethod,
                onClose: returnHome,
                onContinueShopping: returnHome,
                onOrderDetails: { presentedMessage = "주문 상세 화면은 아직 연결되지 않았어요." }
            )
        } else if isShowingCheckoutPayment {
            CheckoutPaymentView(
                onBack: { isShowingCheckoutPayment = false },
                onPaymentComplete: completeCheckout
            )
        } else if isShowingCheckoutAddress {
            CheckoutAddressView(
                onBack: { isShowingCheckoutAddress = false },
                onNext: { isShowingCheckoutPayment = true }
            )
        } else {
            primaryContent(content)
        }
    }

    @ViewBuilder
    private func primaryContent(_ content: HomeContent) -> some View {
        if let selectedProduct {
            ProductDetailView(
                product: selectedProduct,
                onBack: { self.selectedProduct = nil },
                onQuoteTap: { presentedRoute = .quoteInquiry(selectedProduct) }
            )
        } else {
            tabContent(content)
        }
    }

    @ViewBuilder
    private func tabContent(_ content: HomeContent) -> some View {
        switch selectedTab {
        case .cart:
            CartView(cartCount: content.cartCount, onSelectTab: selectTab, onCheckout: { isShowingCheckoutAddress = true })
        case .search:
            SearchView(
                searchText: $searchText,
                cartCount: content.cartCount,
                products: content.recommendedProducts + content.bestSellerProducts,
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onProductTap: { selectedProduct = $0 },
                onBack: { selectedTab = searchReturnTab },
                onSelectTab: selectTab
            )
        case .account:
            accountView(cartCount: content.cartCount)
        case .category:
            categoryView(content)
        case .home:
            homeView(content)
        }
    }

    @ViewBuilder
    private func accountView(cartCount: Int) -> some View {
        if isGuestAccount {
            GuestMyPageView(
                cartCount: cartCount,
                onLoginTap: { presentedRoute = .authentication },
                onSettingsTap: { presentedRoute = .settings },
                onSelectTab: selectTab
            )
        } else {
            MyPageView(
                cartCount: cartCount,
                onSelectTab: selectTab,
                onOrderHistoryTap: { presentedRoute = .orderHistory },
                onFavoritesTap: { presentedRoute = .accountCollection(.favorites) },
                onRecentlyViewedTap: { presentedRoute = .accountCollection(.recentlyViewed) },
                onCouponsTap: { presentedRoute = .accountCollection(.coupons) },
                onAddressesTap: { presentedRoute = .accountCollection(.addresses) },
                onQuoteHistoryTap: { presentedRoute = .accountCollection(.quoteHistory) },
                onContactHistoryTap: { presentedRoute = .accountCollection(.contactHistory) },
                onReturnsHistoryTap: { presentedRoute = .returnHistory(backToOrderHistory: false) },
                onAccountVerificationTap: { presentedRoute = .accountVerification }
            )
        }
    }

    @ViewBuilder
    private func categoryView(_ content: HomeContent) -> some View {
        if let selectedProductCategory {
            ProductListView(
                title: selectedProductCategory.title,
                products: content.recommendedProducts + content.bestSellerProducts,
                cartCount: content.cartCount,
                onBack: { self.selectedProductCategory = nil },
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onSelectTab: selectTab,
                onProductTap: { self.selectedProduct = $0 }
            )
        } else {
            CategoryView(
                onSearchTap: { selectTab(.search) },
                onAllProductsTap: {
                    selectedProductCategory = HomeCategory(id: "all", title: "전체 제품", iconName: "CategoryAll")
                },
                onCategoryTap: { categoryID in
                    selectedProductCategory = content.categories.first { $0.id == categoryID }
                },
                onProductTap: { selectedProduct = $0 },
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onSelectTab: selectTab,
                cartCount: content.cartCount
            )
        }
    }

    private func homeView(_ content: HomeContent) -> some View {
        VStack(spacing: 0) {
            EUMTopBar(
                title: "이음산업건설",
                onMenuTap: { withAnimation(.easeOut(duration: 0.2)) { isShowingDrawer = true } },
                onNotificationTap: { presentedRoute = .accountCollection(.notifications) }
            )
            HomeLandingContentView(
                content: content,
                searchText: $searchText,
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onQuoteTap: { presentedRoute = .quoteInquiry(nil) }
            )
            EUMTabBar(selectedTab: selectedTab, cartCount: content.cartCount, onSelect: selectTab)
    }
    }

    private func selectTab(_ tab: EUMTabBar.Tab) {
        if tab == .search {
            if selectedTab != .search {
                searchReturnTab = selectedTab
            }
            selectedTab = .search
        } else {
            selectedTab = tab
            selectedProductCategory = nil
            selectedProduct = nil
        }
    }

    private func returnHome() {
        isShowingCheckoutAddress = false
        isShowingCheckoutPayment = false
        isShowingCheckoutComplete = false
        selectedTab = .home
    }

    @ViewBuilder
    private func routeView(_ route: HomeModalRoute) -> some View {
        switch route {
        case .authentication: AuthenticationFlowView(onClose: { presentedRoute = nil })
        case .settingsLogin: AuthenticationFlowView(onClose: { presentedRoute = .settings })
        case let .quoteInquiry(product):
            QuoteInquiryView(
                product: product,
                onBack: { presentedRoute = nil },
                onViewInquiries: { presentedRoute = .accountCollection(.quoteHistory) }
            )
        case let .accountCollection(destination):
            HomeAccountCollectionRouteView(
                destination: destination,
                addressViewModel: addressesViewModel,
                onBack: { presentedRoute = nil },
                onRoute: { presentedRoute = $0 },
                onMessage: { presentedMessage = $0 },
                onProductTap: openProductDetail,
                onWithdrawTap: showWithdrawalEntry
            )
        case .orderHistory, .orderDetail, .deliveryTracking, .returnRequest, .returnHistory, .quoteDetail:
            HomeOrderRouteView(
                route: route,
                onBack: { presentedRoute = nil },
                onRoute: { presentedRoute = $0 },
                onMessage: { presentedMessage = $0 }
            )
        case .accountVerification:
            AccountVerificationRouteView(
                onBack: { presentedRoute = nil },
                onVerified: { presentedRoute = .accountCollection(.editProfile) },
                onMessage: { presentedMessage = $0 }
            )
        case .settings, .terms, .termsPrevious, .privacyPolicy:
            HomeLegalRouteView(
                route: route,
                isGuestAccount: isGuestAccount,
                actions: HomeLegalRouteView.Actions(
                    back: { presentedRoute = nil },
                    backToSettings: { presentedRoute = .settings },
                    login: { presentedRoute = .settingsLogin },
                    openTerms: { presentedRoute = .terms },
                    openPrivacyPolicy: { presentedRoute = .privacyPolicy },
                    message: { presentedMessage = $0 },
                    logout: {
                        presentedRoute = nil
                        isGuestAccount = true
                        selectedTab = .account
                    },
                    withdrawal: showWithdrawalEntry
                )
            )
        case .accountWithdrawalNotice, .accountWithdrawalBlocked, .accountWithdrawalReason, .accountWithdrawalComplete:
            accountWithdrawalRouteView(route)
        case let .addressEditor(address):
            AddressEditorRouteView(
                address: address,
                onBack: { presentedRoute = .accountCollection(.addresses) },
                onSave: { addressesViewModel.save($0); presentedRoute = .accountCollection(.addresses) }
            )
        }
    }

    private var loadError: some View {
        VStack(spacing: 16) {
            Text("홈 정보를 불러오지 못했어요.")
                .font(EUMTypography.bodyMedium)
                .foregroundStyle(EUMColor.text2SwiftUI)
            EUMButton(title: "다시 시도", kind: .secondary) {
                Task { await viewModel.retry() }
            }
            .frame(maxWidth: 180)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension HomeView {
    func openProductDetail(_ product: HomeProduct) {
        presentedRoute = nil
        selectedProduct = product
    }

    @ViewBuilder
    func accountWithdrawalRouteView(_ route: HomeModalRoute) -> some View {
        switch route {
        case .accountWithdrawalNotice:
            AccountWithdrawalNoticeView(
                viewModel: withdrawalNoticeViewModel,
                onBack: { presentedRoute = .accountCollection(.editProfile) },
                onContinue: { presentedRoute = .accountWithdrawalReason }
            )
        case .accountWithdrawalBlocked:
            AccountWithdrawalBlockedView(
                viewModel: AccountWithdrawalBlockedViewModel(activeOrderCount: activeWithdrawalOrderCount),
                onBack: { presentedRoute = .accountCollection(.editProfile) },
                onOrderHistory: { presentedRoute = .orderHistory }
            )
        case .accountWithdrawalReason:
            AccountWithdrawalReasonView(
                onBack: { presentedRoute = .accountWithdrawalNotice },
                onSubmit: { presentedRoute = .accountWithdrawalComplete }
            )
        case .accountWithdrawalComplete:
            AccountWithdrawalCompleteView(onHome: returnHome)
        default:
            EmptyView()
        }
    }

    func showWithdrawalEntry() {
        presentedRoute = activeWithdrawalOrderCount > 0 ? .accountWithdrawalBlocked : .accountWithdrawalNotice
    }

    var activeWithdrawalOrderCount: Int {
        OrderHistoryItem.samples.filter { $0.status != .delivered }.count
    }

    func completeCheckout(paymentMethod: CheckoutPaymentMethod) {
        completedPaymentMethod = paymentMethod
        isShowingCheckoutComplete = true
    }

}
