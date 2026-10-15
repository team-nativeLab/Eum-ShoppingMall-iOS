import XCTest
@testable import EumShoppingMall

@MainActor
final class CartViewModelTests: XCTestCase {
    func testMockCartHasTwoSelectedItemsAndOneSoldOutItem() {
        let viewModel = CartViewModel()

        XCTAssertEqual(viewModel.items.count, 3)
        XCTAssertEqual(viewModel.selectedCount, 2)
        XCTAssertTrue(viewModel.items.last?.isSoldOut == true)
    }

    func testSelectAllDoesNotSelectSoldOutItem() {
        let viewModel = CartViewModel()

        viewModel.toggleSelection(itemID: "cart-1")
        viewModel.toggleSelectAll()

        XCTAssertEqual(viewModel.selectedCount, 2)
        XCTAssertFalse(viewModel.items.last?.isSelected ?? true)
    }

    func testQuantityCannotFallBelowOneAndSoldOutQuantityDoesNotChange() {
        let viewModel = CartViewModel()

        viewModel.changeQuantity(itemID: "cart-1", by: -1)
        viewModel.changeQuantity(itemID: "cart-3", by: 1)

        XCTAssertEqual(viewModel.items.first?.quantity, 1)
        XCTAssertEqual(viewModel.items.last?.quantity, 1)
    }

    func testRemoveSelectedLeavesSoldOutItem() {
        let viewModel = CartViewModel()

        viewModel.removeSelected()

        XCTAssertEqual(viewModel.items.map(\.id), ["cart-3"])
        XCTAssertEqual(viewModel.selectedCount, 0)
    }
}
