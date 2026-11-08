import XCTest
@testable import EumShoppingMall

@MainActor
final class CheckoutCompleteViewModelTests: XCTestCase {
    func testCompletionShowsMockOrderSummaryFromDesign() {
        let viewModel = CheckoutCompleteViewModel()

        XCTAssertEqual(viewModel.order.orderNumber, "0000000000")
        XCTAssertEqual(viewModel.order.paymentAmount, "₩00,000")
        XCTAssertEqual(viewModel.order.paymentMethod, .creditCard)
        XCTAssertEqual(viewModel.order.shippingAddress, "서울특별시 00구 00로 00")
    }

    func testVirtualAccountCompletionHasDepositInformation() {
        let viewModel = CheckoutCompleteViewModel(paymentMethod: .virtualAccount)

        XCTAssertEqual(viewModel.order.paymentMethod, .virtualAccount)
        XCTAssertEqual(viewModel.bankName, "00은행")
        XCTAssertEqual(viewModel.accountNumber, "000-000000-00000")
        XCTAssertEqual(viewModel.accountHolder, "예금주명")
        XCTAssertEqual(viewModel.depositDeadline, "0000.00.00 00:00까지")
    }
}
