import XCTest
@testable import EumShoppingMall

@MainActor
final class QuoteDetailViewModelTests: XCTestCase {
    func testQuoteSentInquiryShowsQuoteSentProgressStep() {
        let viewModel = QuoteDetailViewModel(inquiry: sampleInquiry(status: .quoteSent))

        XCTAssertEqual(viewModel.currentStepIndex, 2)
        XCTAssertEqual(viewModel.amount, "₩00,000")
        XCTAssertEqual(viewModel.products.count, 2)
    }

    func testCompletedInquiryShowsFinalProgressStep() {
        let viewModel = QuoteDetailViewModel(inquiry: sampleInquiry(status: .completed))

        XCTAssertEqual(viewModel.currentStepIndex, 3)
    }

    private func sampleInquiry(status: QuoteInquiryStatus) -> QuoteInquiryRecord {
        QuoteInquiryRecord(
            id: "quote-detail-test",
            date: "0000.00.00",
            inquiryNumber: "0000000000",
            status: status,
            title: "견적 문의 제목",
            productSummary: "제품명 외 0건 · 총 0개",
            showsDocument: true
        )
    }
}
