import XCTest
@testable import EumShoppingMall

@MainActor
final class CheckoutCompleteViewModelTests: XCTestCase {
    func testCompletionShowsMockOrderSummaryFromDesign() {
        let viewModel = CheckoutCompleteViewModel()

        XCTAssertEqual(viewModel.order.orderNumber, "0000000000")
        XCTAssertEqual(viewModel.order.paymentAmount, "₩00,000")
        XCTAssertEqual(viewModel.order.paymentMethod, "신용카드")
        XCTAssertEqual(viewModel.order.shippingAddress, "서울특별시 00구 00로 00")
    }
}
