import XCTest
@testable import EumShoppingMall

@MainActor
final class CheckoutAddressViewModelTests: XCTestCase {
    func testMockOrderSummaryContainsTwoItems() {
        let viewModel = CheckoutAddressViewModel()

        XCTAssertEqual(viewModel.orderItems.count, 2)
        XCTAssertEqual(viewModel.orderSummaryTitle, "제품명 외 1건")
        XCTAssertTrue(viewModel.isOrderItemsExpanded)
    }

    func testOrderItemsCanBeCollapsedAndExpanded() {
        let viewModel = CheckoutAddressViewModel()

        viewModel.toggleOrderItems()
        XCTAssertFalse(viewModel.isOrderItemsExpanded)

        viewModel.toggleOrderItems()
        XCTAssertTrue(viewModel.isOrderItemsExpanded)
    }
}
