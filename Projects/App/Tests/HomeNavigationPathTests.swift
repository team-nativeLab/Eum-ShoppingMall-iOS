import XCTest
@testable import EumShoppingMall

final class HomeNavigationPathTests: XCTestCase {
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
