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

    @MainActor
    func testCompletionDetailsUseMockReferenceAndSubmittedFields() {
        let viewModel = QuoteInquiryViewModel()
        viewModel.inquiryType = .bulk
        viewModel.deliveryDate = "2026.10.16"
        viewModel.addSampleProduct()

        XCTAssertEqual(viewModel.completionDetails.inquiryNumber, "Q-00000000-000")
        XCTAssertEqual(viewModel.completionDetails.inquiryType, "대량 구매")
        XCTAssertEqual(viewModel.completionDetails.productSummary, "제품명 외 1건")
        XCTAssertEqual(viewModel.completionDetails.deliveryDate, "2026.10.16")
    }
}
