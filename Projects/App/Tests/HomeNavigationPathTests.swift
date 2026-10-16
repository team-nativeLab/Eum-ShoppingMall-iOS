import XCTest
@testable import EumShoppingMall

final class HomeNavigationPathTests: XCTestCase {
    func testHomeCategoryProductListBackReturnsToHome() {
        var state = HomeNavigationState()
        state.push(.productList(HomeProductListSelection(title: "개인보호장비", products: [product("ppe")])))

        XCTAssertEqual(state.selectedTab, .home)
        state.back()

        XCTAssertEqual(state.selectedTab, .home)
        XCTAssertTrue(state.isEmpty)
    }

    func testCategoryProductListBackReturnsToCategory() {
        var state = HomeNavigationState()
        state.selectTab(.category)
        state.push(.productList(HomeProductListSelection(title: "개인보호장비", products: [product("ppe")])))
        state.back()

        XCTAssertEqual(state.selectedTab, .category)
        XCTAssertTrue(state.isEmpty)
    }

    func testSearchBackReturnsToProductListThenListBackReturnsToOrigin() {
        var state = HomeNavigationState()
        state.push(.productList(HomeProductListSelection(title: "추천 제품", products: [product("recommended")])))
        state.push(.contextualSearch)

        state.back()

        XCTAssertEqual(state.selectedTab, .home)
        guard case let .productList(selection)? = state.entries.last?.destination else {
            return XCTFail("Contextual search back must return to the same product list")
        }
        XCTAssertEqual(selection.title, "추천 제품")
        let listID = state.topID
        state.push(.product(product("from-search")))
        state.back()
        XCTAssertEqual(state.topID, listID)
        guard case let .productList(restoredSelection)? = state.entries.last?.destination else {
            return XCTFail("Product detail back must return to the existing product list")
        }
        XCTAssertEqual(restoredSelection.title, "추천 제품")
        state.back()
        XCTAssertEqual(state.selectedTab, .home)
        XCTAssertTrue(state.isEmpty)
    }

    func testSelectingAnotherTabClearsProductList() {
        var state = HomeNavigationState()
        state.push(.productList(HomeProductListSelection(title: "추천 제품", products: [product("recommended")])))
        state.selectTab(.cart)

        XCTAssertEqual(state.selectedTab, .cart)
        XCTAssertTrue(state.isEmpty)
    }

    func testSearchTabBackReturnsToOriginatingTab() {
        var state = HomeNavigationState()
        state.selectTab(.category)
        state.push(.screen(.accountCollection(.favorites)))

        state.selectTab(.search)

        XCTAssertTrue(state.isEmpty)
        XCTAssertEqual(state.selectedTab, .search)
        state.backFromSearch()
        XCTAssertEqual(state.selectedTab, .category)
    }

    func testContextualSearchBackReturnsToCategoryScreen() {
        var state = HomeNavigationState()
        state.selectTab(.category)
        state.push(.contextualSearch)

        state.back()

        XCTAssertEqual(state.selectedTab, .category)
        XCTAssertTrue(state.isEmpty)
    }

    func testReturningHomeClearsNestedScreens() {
        var state = HomeNavigationState()
        state.push(.productList(HomeProductListSelection(title: "개인보호장비", products: [product("ppe")])))
        state.push(.product(product("ppe-detail")))

        state.returnHome()

        XCTAssertEqual(state.selectedTab, .home)
        XCTAssertTrue(state.isEmpty)
    }

    func testRelatedProductBackReturnsToProductThenOriginalFavorites() {
        var path = HomeNavigationPath()
        path.push(.screen(.accountCollection(.favorites)))
        let favoritesID = path.topID
        path.push(.product(product("first")))
        let productID = path.topID
        path.push(.product(product("related")))

        path.back()
        XCTAssertEqual(path.topID, productID)
        guard case let .product(product) = path.entries.last?.destination else {
            return XCTFail("Related product back must return to the previous product")
        }
        XCTAssertEqual(product.id, "first")
        path.back()
        XCTAssertEqual(path.topID, favoritesID)
        guard case .screen(.accountCollection(.favorites)) = path.entries.last?.destination else {
            return XCTFail("Product back must return to the original favorites list")
        }
    }

    func testAddressEditorReturnsThroughAddressListToSameReturnRequest() {
        var path = HomeNavigationPath()
        path.push(.screen(.returnRequest(OrderHistoryItem.samples[3])))
        let requestID = path.topID
        path.push(.screen(.accountCollection(.addresses)))
        let addressesID = path.topID
        path.push(.screen(.addressEditor(nil)))

        path.back()
        XCTAssertEqual(path.topID, addressesID)
        path.back()
        XCTAssertEqual(path.topID, requestID)
        XCTAssertEqual(path.entries.count, 1)
    }

    func testOrderDetailsReturnToCheckoutCompletionAndCloseClearsEntireFlow() {
        var path = HomeNavigationPath()
        path.push(.product(product("purchase")))
        path.push(.checkoutAddress)
        path.push(.checkoutPayment)
        path.push(.checkoutComplete(.virtualAccount))
        let completionID = path.topID
        path.push(.screen(.orderDetail(OrderHistoryItem.samples[0])))

        path.back()
        XCTAssertEqual(path.topID, completionID)
        guard case .checkoutComplete(.virtualAccount) = path.entries.last?.destination else {
            return XCTFail("Order details must return to the originating completion")
        }
        path.reset()
        path.back()
        XCTAssertTrue(path.isEmpty)
        XCTAssertNil(path.topID)
    }

    private func product(_ id: String) -> HomeProduct {
        HomeProduct(
            id: id, title: id, price: "₩00,000", imageName: nil,
            isFavorite: false, isSoldOut: false, isPriceHidden: false
        )
    }
}
