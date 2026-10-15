import XCTest
@testable import EumShoppingMall

final class QuoteInquiryViewModelTests: XCTestCase {
    @MainActor
    func testQuoteInquiryRequiresPrivacyAgreementAndValidMemberFields() {
        let viewModel = QuoteInquiryViewModel()
        XCTAssertFalse(viewModel.canSubmit)

        viewModel.togglePrivacyAgreement()
        XCTAssertTrue(viewModel.canSubmit)

        viewModel.email = "invalid-email"
        XCTAssertFalse(viewModel.canSubmit)
    }

    @MainActor
    func testQuoteProductsCanBeAddedAndRemoved() {
        let viewModel = QuoteInquiryViewModel()
        XCTAssertEqual(viewModel.products.count, 1)

        viewModel.addSampleProduct()
        XCTAssertEqual(viewModel.products.count, 2)
        viewModel.removeProduct(id: viewModel.products[0].id)
        XCTAssertEqual(viewModel.products.count, 1)
        viewModel.removeProduct(id: viewModel.products[0].id)
        XCTAssertFalse(viewModel.canSubmit)
    }

    @MainActor
    func testQuoteSubmissionRejectsDetailsLongerThanOneThousandCharacters() {
        let viewModel = QuoteInquiryViewModel()
        viewModel.details = String(repeating: "a", count: 1_000)
        viewModel.togglePrivacyAgreement()
        XCTAssertTrue(viewModel.canSubmit)

        viewModel.details.append("a")
        XCTAssertFalse(viewModel.canSubmit)
    }
}
