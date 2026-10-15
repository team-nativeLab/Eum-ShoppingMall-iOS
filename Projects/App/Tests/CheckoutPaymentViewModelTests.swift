import XCTest
@testable import EumShoppingMall

@MainActor
final class CheckoutPaymentViewModelTests: XCTestCase {
    func testDefaultPaymentChoicesMatchDesignAndRequireAgreement() {
        let viewModel = CheckoutPaymentViewModel()

        XCTAssertEqual(viewModel.selectedPaymentMethod, .creditCard)
        XCTAssertEqual(viewModel.selectedReceiptOption, .cashReceipt)
        XCTAssertFalse(viewModel.isOrderAgreementAccepted)
        XCTAssertFalse(viewModel.canPay)
        XCTAssertEqual(viewModel.availableCouponCount, 0)
        XCTAssertEqual(viewModel.availablePoints, 0)
    }

    func testPaymentMethodAndReceiptCanBeChanged() {
        let viewModel = CheckoutPaymentViewModel()

        viewModel.selectPaymentMethod(.virtualAccount)
        viewModel.selectReceiptOption(.taxInvoice)

        XCTAssertEqual(viewModel.selectedPaymentMethod, .virtualAccount)
        XCTAssertEqual(viewModel.selectedReceiptOption, .taxInvoice)
    }

    func testAgreementControlsPaymentAvailability() {
        let viewModel = CheckoutPaymentViewModel()

        viewModel.toggleOrderAgreement()
        XCTAssertTrue(viewModel.canPay)

        viewModel.toggleOrderAgreement()
        XCTAssertFalse(viewModel.canPay)
    }
}
