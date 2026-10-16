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

    func testTaxInvoicePreviewCanStartWithBusinessReceiptSelected() {
        let viewModel = CheckoutPaymentViewModel(initialReceiptOption: .taxInvoice)

        XCTAssertEqual(viewModel.selectedReceiptOption, .taxInvoice)
    }

    func testDirectTaxInvoiceInfoRequiresValidFieldsBeforePayment() {
        let viewModel = CheckoutPaymentViewModel(
            initialReceiptOption: .taxInvoice,
            startsWithDirectTaxInvoiceInput: true
        )
        viewModel.toggleOrderAgreement()

        XCTAssertFalse(viewModel.canPay)

        viewModel.updateBusinessRegistrationNumber("123-45678901")
        viewModel.taxInvoiceCompanyName = "회사명"
        viewModel.taxInvoiceRepresentativeName = "홍길동"
        viewModel.taxInvoiceEmail = "example@email.com"

        XCTAssertEqual(viewModel.businessRegistrationNumber, "1234567890")
        XCTAssertTrue(viewModel.isTaxInvoiceInfoValid)
        XCTAssertTrue(viewModel.canPay)
    }

    func testAgreementControlsPaymentAvailability() {
        let viewModel = CheckoutPaymentViewModel()

        viewModel.toggleOrderAgreement()
        XCTAssertTrue(viewModel.canPay)

        viewModel.toggleOrderAgreement()
        XCTAssertFalse(viewModel.canPay)
    }
}
