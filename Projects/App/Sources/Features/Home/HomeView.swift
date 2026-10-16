import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @StateObject private var addressesViewModel = AddressesViewModel()
    @StateObject private var withdrawalNoticeViewModel = AccountWithdrawalNoticeViewModel()
    @State private var searchText = ""
    @State private var selectedTab = EUMTabBar.Tab.home
    @State private var searchReturnTab = EUMTabBar.Tab.home
    @State private var selectedProductList: HomeProductListSelection?
    @State private var navigation = HomeNavigationPath()
    @State private var isShowingDrawer = false
    @State private var isGuestAccount = false
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
                        openRoute(.quoteInquiry(nil))
                    } else if destination == "회사소개" {
                        companyIntroductionReturnsToDrawer = true
                        openRoute(.companyIntroduction)
                    } else if destination == "고객지원" {
                        openRoute(.customerCenter)
                    } else if destination == "공지사항" {
                        openRoute(.announcements)
                    } else {
                        presentedMessage = "\(destination) 화면은 아직 연결되지 않았어요."
                    }
                },
                onSettings: {
                    isShowingDrawer = false
                    openRoute(.settings)
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
    private func tabContent(_ content: HomeContent) -> some View {
        switch selectedTab {
        case .cart:
            CartView(
                cartCount: content.cartCount,
                onSelectTab: selectTab,
                onCheckout: { navigation.push(.checkoutAddress) },
                onProductTap: { openProductDetail($0.homeProduct) },
                onQuoteRequest: { openRoute(.quoteInquiry($0.homeProduct)) }
            )
        case .search:
            SearchView(
                searchText: $searchText,
                cartCount: content.cartCount,
                products: content.recommendedProducts + content.bestSellerProducts,
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onProductTap: openProductDetail,
                onQuoteTap: { openRoute(.quoteInquiry(nil)) },
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
            onRoute: openRoute,
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
                        openRoute(.quoteInquiry(nil))
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
                onNotificationTap: { openRoute(.accountCollection(.notifications)) }
            )
            HomeLandingContentView(
                content: content,
                searchText: $searchText,
                onFavoriteTap: { viewModel.toggleFavorite(productID: $0) },
                onQuoteTap: { openRoute(.quoteInquiry(nil)) },
                onSearchSubmit: { selectTab(.search) },
                onHeroTap: {
                    companyIntroductionReturnsToDrawer = false
                    openRoute(.companyIntroduction)
                },
                onCategoryTap: { category in
                    if category.id == "custom" {
                        openRoute(.quoteInquiry(nil))
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
        navigation.reset()
        companyIntroductionReturnsToDrawer = false
        if tab == .search {
            if selectedTab != .search { searchReturnTab = selectedTab }
        } else {
            selectedProductList = nil
        }
        selectedTab = tab
    }

    private func returnHome() {
        navigation.reset()
        companyIntroductionReturnsToDrawer = false
        selectedProductList = nil
        selectedTab = .home
    }

    private func openRoute(_ route: HomeModalRoute) {
        navigation.push(.screen(route))
    }

    private func goBack() {
        navigation.back()
        if navigation.isEmpty && companyIntroductionReturnsToDrawer {
            isShowingDrawer = true
            companyIntroductionReturnsToDrawer = false
        }
    }

    private func logout() {
        navigation.reset()
        companyIntroductionReturnsToDrawer = false
        isGuestAccount = true
        selectedTab = .account
    }

    private func openProductList(title: String, products: [HomeProduct]) {
        selectedProductList = HomeProductListSelection(title: title, products: products)
        selectedTab = .category
    }

    private func openProductDetail(_ product: HomeProduct) {
        navigation.push(.product(product))
    }

    private func showWithdrawalEntry() {
        openRoute(activeWithdrawalOrderCount > 0 ? .accountWithdrawalBlocked : .accountWithdrawalNotice)
    }

    private var activeWithdrawalOrderCount: Int {
        OrderHistoryItem.samples.filter { $0.status != .delivered }.count
    }
}

private extension HomeView {
    func contentView(_ content: HomeContent) -> some View {
        ZStack {
            tabContent(content)
                .navigationLayer(isActive: navigation.isEmpty)
            ForEach(navigation.entries) { entry in
                destinationView(entry.destination)
                    .navigationLayer(isActive: entry.id == navigation.topID)
            }
        }
    }

    @ViewBuilder
    func destinationView(_ destination: HomeDestination) -> some View {
        switch destination {
        case let .screen(route):
            modalRouteHost(route)
        case let .product(product):
            ProductDetailView(
                product: product,
                onBack: goBack,
                onQuoteTap: { openRoute(.quoteInquiry(product)) },
                onOpenCart: { selectTab(.cart) },
                onPurchase: { navigation.push(.checkoutAddress) },
                onRelatedProductTap: openProductDetail
            )
        case .checkoutAddress:
            CheckoutAddressView(
                onBack: goBack,
                onNext: { navigation.push(.checkoutPayment) },
                onAddressChange: { openRoute(.accountCollection(.addresses)) }
            )
        case .checkoutPayment:
            CheckoutPaymentView(
                onBack: goBack,
                onPaymentComplete: { navigation.push(.checkoutComplete($0)) }
            )
        case let .checkoutComplete(paymentMethod):
            CheckoutCompleteView(
                paymentMethod: paymentMethod,
                onClose: returnHome,
                onContinueShopping: returnHome,
                onOrderDetails: {
                    let index = paymentMethod == .virtualAccount ? 0 : 1
                    openRoute(.orderDetail(OrderHistoryItem.samples[index]))
                }
            )
        }
    }

    func modalRouteHost(_ route: HomeModalRoute) -> some View {
        HomeModalRouteHostView(
            route: route,
            addressViewModel: addressesViewModel,
            withdrawalNoticeViewModel: withdrawalNoticeViewModel,
            isGuestAccount: isGuestAccount,
            activeWithdrawalOrderCount: activeWithdrawalOrderCount,
            onBack: goBack,
            onRoute: openRoute,
            onMessage: { presentedMessage = $0 },
            onProductTap: openProductDetail,
            onAddressChange: { _ in openRoute(.accountCollection(.addresses)) },
            onHome: returnHome,
            onWithdrawal: showWithdrawalEntry,
            onLogout: logout
        )
    }
}

private extension View {
    func navigationLayer(isActive: Bool) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isActive ? 1 : 0)
            .allowsHitTesting(isActive)
            .accessibilityHidden(!isActive)
    }
}
