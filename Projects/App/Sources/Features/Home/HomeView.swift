import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @StateObject private var addressesViewModel = AddressesViewModel()
    @StateObject private var withdrawalNoticeViewModel = AccountWithdrawalNoticeViewModel()
    @State private var searchText = ""
    @State private var selectedTab = EUMTabBar.Tab.home
    @State private var searchReturnTab = EUMTabBar.Tab.home
    @State private var selectedProductList: HomeProductListSelection?
    @State private var selectedProduct: HomeProduct?
    @State private var productDetailBackStack: [HomeProduct] = []
    @State private var presentedRoute: HomeModalRoute?
    @State private var isShowingDrawer = false
    @State private var isGuestAccount = false
    @State private var isShowingCheckoutAddress = false
    @State private var isShowingCheckoutPayment = false
    @State private var isShowingCheckoutComplete = false
    @State private var orderDetailReturnsToCheckoutComplete = false
    @State private var completedPaymentMethod: CheckoutPaymentMethod = .creditCard
    @State private var addressesReturnRoute: HomeModalRoute?
    @State private var routeBackStack: [HomeModalRoute] = []
    @State private var presentedMessage: String?
    @State private var companyIntroductionReturnsToDrawer = false

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
                HomeLoadErrorView(onRetry: { Task { await viewModel.retry() } })
            }
        }
        .background(EUMColor.backgroundSwiftUI.ignoresSafeArea())
        .overlay {
            AppDrawerView(
                isPresented: $isShowingDrawer,
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
                    } else if destination == "회사소개" {
                        companyIntroductionReturnsToDrawer = true
                        presentedRoute = .companyIntroduction
                    } else if destination == "고객지원" {
                        presentedRoute = .customerCenter
                    } else if destination == "공지사항" {
                        presentedRoute = .announcements
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
            .zIndex(isShowingDrawer ? 1 : 0)
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
    private func primaryContent(_ content: HomeContent) -> some View {
        if let selectedProduct {
            ProductDetailView(
                product: selectedProduct,
                onBack: closeProductDetail,
                onQuoteTap: { presentedRoute = .quoteInquiry(selectedProduct) },
                onOpenCart: { selectTab(.cart) },
                onPurchase: { isShowingCheckoutAddress = true },
                onRelatedProductTap: openProductDetail
            )
        } else {
            tabContent(content)
        }
    }

    @ViewBuilder
    private func tabContent(_ content: HomeContent) -> some View {
        switch selectedTab {
        case .cart:
            CartView(
                cartCount: content.cartCount,
                onSelectTab: selectTab,
                onCheckout: { isShowingCheckoutAddress = true },
                onProductTap: { selectedProduct = $0.homeProduct },
                onQuoteRequest: { presentedRoute = .quoteInquiry($0.homeProduct) }
            )
        case .search:
            SearchView(
                searchText: $searchText,
                cartCount: content.cartCount,
                products: content.recommendedProducts + content.bestSellerProducts,
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onProductTap: openProductDetail,
                onQuoteTap: { presentedRoute = .quoteInquiry(nil) },
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
        HomeAccountTabView(
            cartCount: cartCount,
            isGuestAccount: isGuestAccount,
            onSelectTab: selectTab,
            onRoute: openAccountRoute,
            onProductTap: openProductDetail
        )
    }

    @ViewBuilder
    private func categoryView(_ content: HomeContent) -> some View {
        if let selectedProductList {
            ProductListView(
                title: selectedProductList.title,
                products: selectedProductList.products,
                cartCount: content.cartCount,
                onBack: { self.selectedProductList = nil },
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onSelectTab: selectTab,
                onProductTap: openProductDetail,
                onSearchTap: { selectTab(.search) }
            )
        } else {
            CategoryView(
                onSearchTap: { selectTab(.search) },
                onAllProductsTap: {
                    openProductList(title: "전체 제품", products: content.recommendedProducts + content.bestSellerProducts)
                },
                onCategoryTap: { categoryID in
                    if categoryID == "custom" {
                        presentedRoute = .quoteInquiry(nil)
                    } else if let category = content.categories.first(where: { $0.id == categoryID }) {
                        openProductList(title: category.title, products: content.recommendedProducts + content.bestSellerProducts)
                    }
                },
                onProductTap: openProductDetail,
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
                onQuoteTap: { presentedRoute = .quoteInquiry(nil) },
                onSearchSubmit: { selectTab(.search) },
                onHeroTap: {
                    companyIntroductionReturnsToDrawer = false
                    presentedRoute = .companyIntroduction
                },
                onCategoryTap: { category in
                    if category.id == "custom" {
                        presentedRoute = .quoteInquiry(nil)
                    } else {
                        selectTab(.category)
                        openProductList(title: category.title, products: content.recommendedProducts + content.bestSellerProducts)
                    }
                },
                onRecommendedTap: {
                    openProductList(title: "추천 제품", products: content.recommendedProducts)
                },
                onBestSellersTap: {
                    openProductList(title: "베스트 셀러", products: content.bestSellerProducts)
                },
                onProductTap: openProductDetail
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
            selectedProductList = nil
            selectedProduct = nil
            productDetailBackStack.removeAll()
        }
    }

    private func returnHome() {
        isShowingCheckoutAddress = false
        isShowingCheckoutPayment = false
        isShowingCheckoutComplete = false
        presentedRoute = nil
        selectedProduct = nil
        selectedProductList = nil
        productDetailBackStack.removeAll()
        orderDetailReturnsToCheckoutComplete = false
        selectedTab = .home
    }

    private var completedOrder: OrderHistoryItem {
        let sampleIndex = completedPaymentMethod == .virtualAccount ? 0 : 1
        return OrderHistoryItem.samples[sampleIndex]
    }

}

private extension HomeView {
    @ViewBuilder
    func contentView(_ content: HomeContent) -> some View {
        if let route = presentedRoute {
            modalRouteHost(route)
        } else if isShowingCheckoutComplete {
            CheckoutCompleteView(
                paymentMethod: completedPaymentMethod,
                onClose: returnHome,
                onContinueShopping: returnHome,
                onOrderDetails: {
                    orderDetailReturnsToCheckoutComplete = true
                    presentedRoute = .orderDetail(completedOrder)
                }
            )
        } else if isShowingCheckoutPayment {
            CheckoutPaymentView(onBack: { isShowingCheckoutPayment = false }, onPaymentComplete: completeCheckout)
        } else if isShowingCheckoutAddress {
            CheckoutAddressView(
                onBack: { isShowingCheckoutAddress = false },
                onNext: { isShowingCheckoutPayment = true },
                onAddressChange: {
                    addressesReturnRoute = nil
                    presentedRoute = .accountCollection(.addresses)
                }
            )
        } else {
            primaryContent(content)
        }
    }

    func modalRouteHost(_ route: HomeModalRoute) -> some View {
        HomeModalRouteHostView(
            route: route,
            addressViewModel: addressesViewModel,
            withdrawalNoticeViewModel: withdrawalNoticeViewModel,
            isGuestAccount: isGuestAccount,
            activeWithdrawalOrderCount: activeWithdrawalOrderCount,
            onBack: handleModalRouteBack,
            onBackToDrawer: returnFromCompanyIntroduction,
            onRoute: { handleNestedRoute($0, from: route) },
            onMessage: { presentedMessage = $0 },
            onProductTap: openProductDetail,
            onAddressChange: changeAddress,
            onHome: returnHome,
            onWithdrawal: showWithdrawalEntry,
            onLogout: logout
        )
    }

    func handleModalRouteBack(_ route: HomeModalRoute) {
        if case .accountCollection(.addresses) = route, let addressesReturnRoute {
            presentedRoute = addressesReturnRoute
            self.addressesReturnRoute = nil
        } else if case .orderDetail = route {
            if orderDetailReturnsToCheckoutComplete {
                presentedRoute = nil
                isShowingCheckoutComplete = true
                orderDetailReturnsToCheckoutComplete = false
            } else {
                presentedRoute = .orderHistory
            }
        } else if case .accountCollection(.quoteHistory) = route,
                  let returnRoute = routeBackStack.popLast() {
            presentedRoute = returnRoute
        } else if case .accountCollection(.contactHistory) = route,
                  let returnRoute = routeBackStack.popLast() {
            presentedRoute = returnRoute
        } else if case .customerCenter = route, let returnRoute = routeBackStack.popLast() {
            presentedRoute = returnRoute
        } else {
            presentedRoute = nil
        }
    }

    func handleNestedRoute(_ destination: HomeModalRoute, from route: HomeModalRoute) {
        if case .quoteInquiry = route, case .accountCollection(.quoteHistory) = destination {
            routeBackStack.append(route)
        } else if case .usageGuide = route, case .customerCenter = destination {
            routeBackStack.append(route)
        } else if case .customerCenter = route, case .accountCollection(.contactHistory) = destination {
            routeBackStack.append(route)
        }
        presentedRoute = destination
    }

    func returnFromCompanyIntroduction() {
        presentedRoute = nil
        if companyIntroductionReturnsToDrawer { isShowingDrawer = true }
        companyIntroductionReturnsToDrawer = false
    }

    func changeAddress(for order: OrderHistoryItem) {
        addressesReturnRoute = .returnRequest(order)
        presentedRoute = .accountCollection(.addresses)
    }

    func logout() {
        presentedRoute = nil
        isGuestAccount = true
        selectedTab = .account
    }

    func openAccountRoute(_ route: HomeModalRoute) {
        if case .accountCollection(.addresses) = route {
            addressesReturnRoute = nil
        }
        presentedRoute = route
    }

    func openProductList(title: String, products: [HomeProduct]) {
        selectedProduct = nil
        productDetailBackStack.removeAll()
        selectedProductList = HomeProductListSelection(title: title, products: products)
        selectedTab = .category
    }

    func openProductDetail(_ product: HomeProduct) {
        presentedRoute = nil
        if let selectedProduct {
            productDetailBackStack.append(selectedProduct)
        }
        selectedProduct = product
    }

    func closeProductDetail() {
        selectedProduct = productDetailBackStack.popLast()
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
