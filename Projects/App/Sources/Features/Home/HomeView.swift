import SwiftUI

private enum HomeModalRoute {
    case authentication
    case quoteInquiry(HomeProduct?)
    case accountCollection(AccountCollectionDestination)
    case orderHistory
    case orderDetail(OrderHistoryItem)
    case deliveryTracking(OrderHistoryItem)
    case returnRequest(OrderHistoryItem)
    case returnHistory(backToOrderHistory: Bool)
    case accountVerification
}

private enum AccountCollectionDestination {
    case favorites
    case recentlyViewed
    case coupons
    case points
}

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
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
                        presentedMessage = "설정 화면은 아직 연결되지 않았어요."
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
                onClose: returnHome,
                onContinueShopping: returnHome,
                onOrderDetails: { presentedMessage = "주문 상세 화면은 아직 연결되지 않았어요." }
            )
        } else if isShowingCheckoutPayment {
            CheckoutPaymentView(
                onBack: { isShowingCheckoutPayment = false },
                onPaymentComplete: { isShowingCheckoutComplete = true }
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
                onNotificationTap: { presentedMessage = "알림 화면은 아직 연결되지 않았어요." }
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
        case .authentication:
            AuthenticationFlowView(onClose: { presentedRoute = nil })
        case let .quoteInquiry(product):
            QuoteInquiryView(product: product, onBack: { presentedRoute = nil })
        case let .accountCollection(destination):
            AccountCollectionRouteView(
                destination: destination,
                onBack: { presentedRoute = nil },
                onBackToCoupons: { presentedRoute = .accountCollection(.coupons) },
                onPointsTap: { presentedRoute = .accountCollection(.points) },
                onProductTap: openProductDetail
            )
        case .orderHistory:
            OrderHistoryView(
                onBack: { presentedRoute = nil },
                onCancelReturn: { presentedRoute = .returnHistory(backToOrderHistory: true) },
                onOrderDetail: { presentedRoute = .orderDetail($0) },
                onCancelOrder: { _ in presentedMessage = "주문 취소는 서버 연동 후 이용할 수 있어요." },
                onTrackDelivery: { _ in presentedMessage = "배송 조회는 서버 연동 후 이용할 수 있어요." },
                onReorder: { _ in presentedMessage = "다시 담기는 장바구니 연결 후 이용할 수 있어요." }
            )
        case let .orderDetail(order):
            OrderDetailView(
                order: order,
                onBack: { presentedRoute = .orderHistory },
                onTrackDelivery: { presentedRoute = .deliveryTracking(order) },
                onReturnExchange: { presentedRoute = .returnRequest(order) },
                onDocumentDownload: { presentedMessage = "거래명세서는 주문 서비스 연동 후 다운로드할 수 있어요." },
                onReceipt: { presentedMessage = "영수증은 주문 서비스 연동 후 확인할 수 있어요." }
            )
        case let .deliveryTracking(order):
            DeliveryTrackingView(order: order, onBack: { presentedRoute = .orderDetail(order) })
        case let .returnRequest(order):
            ReturnRequestView(
                order: order,
                onBack: { presentedRoute = .orderDetail(order) },
                onUnavailableKind: { presentedMessage = "\($0.rawValue) 화면은 별도 작업에서 연결할 예정이에요." },
                onAddressChange: { presentedMessage = "배송지 변경은 배송지 관리 화면 연결 후 이용할 수 있어요." },
                onSubmit: { presentedMessage = $0 }
            )
        case let .returnHistory(backToOrderHistory):
            ReturnHistoryView(
                onBack: { presentedRoute = backToOrderHistory ? .orderHistory : nil },
                onDetail: { _ in presentedMessage = "신청 상세는 서버 연동 후 확인할 수 있어요." },
                onWithdraw: { _ in presentedMessage = "신청 철회는 서버 연동 후 이용할 수 있어요." },
                onRejectionReason: { item in presentedMessage = item.rejectionReason ?? "반려 사유가 없습니다." }
            )
        case .accountVerification:
            AccountVerificationView(
                onBack: { presentedRoute = nil },
                onConfirm: { presentedMessage = $0 }
            )
        }
    }

    private func openProductDetail(_ product: HomeProduct) {
        presentedRoute = nil
        selectedProduct = product
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

private struct AccountCollectionRouteView: View {
    let destination: AccountCollectionDestination
    let onBack: () -> Void
    let onBackToCoupons: () -> Void
    let onPointsTap: () -> Void
    let onProductTap: (HomeProduct) -> Void

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
            PointsView(onBack: onBackToCoupons)
        }
    }
}

struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
