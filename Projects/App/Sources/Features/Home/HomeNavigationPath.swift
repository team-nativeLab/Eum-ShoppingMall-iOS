import Foundation

enum HomeDestination {
    case screen(HomeModalRoute)
    case product(HomeProduct)
    case productList(HomeProductListSelection)
    case contextualSearch
    case checkoutAddress
    case checkoutPayment
    case checkoutComplete(CheckoutPaymentMethod)
}

struct HomeNavigationEntry: Identifiable {
    let id = UUID()
    let destination: HomeDestination
}

struct HomeNavigationPath {
    private(set) var entries: [HomeNavigationEntry] = []

    var isEmpty: Bool { entries.isEmpty }
    var topID: UUID? { entries.last?.id }

    mutating func push(_ destination: HomeDestination) {
        entries.append(HomeNavigationEntry(destination: destination))
    }

    mutating func back() {
        _ = entries.popLast()
    }

    mutating func reset() {
        entries.removeAll()
    }

    mutating func resetAndPush(_ destination: HomeDestination) {
        reset()
        push(destination)
    }
}

struct HomeNavigationState {
    private(set) var selectedTab = EUMTabBar.Tab.home
    private(set) var searchReturnTab = EUMTabBar.Tab.home
    private var path = HomeNavigationPath()

    var entries: [HomeNavigationEntry] { path.entries }
    var isEmpty: Bool { path.isEmpty }
    var topID: UUID? { path.topID }

    mutating func push(_ destination: HomeDestination) {
        path.push(destination)
    }

    mutating func back() {
        path.back()
    }

    mutating func resetAndPush(_ destination: HomeDestination) {
        path.resetAndPush(destination)
    }

    mutating func selectTab(_ tab: EUMTabBar.Tab) {
        path.reset()
        if tab == .search, selectedTab != .search {
            searchReturnTab = selectedTab
        }
        selectedTab = tab
    }

    mutating func backFromSearch() {
        selectedTab = searchReturnTab
    }

    mutating func returnHome() {
        path.reset()
        selectedTab = .home
    }
}
