import XCTest
@testable import EumShoppingMall

@MainActor
final class QuoteHistoryViewModelTests: XCTestCase {
    func testStartsWithAllFiveMockStatuses() {
        let viewModel = QuoteHistoryViewModel()

        XCTAssertEqual(viewModel.visibleInquiries.count, 5)
        XCTAssertEqual(viewModel.visibleInquiries.map(\.status), [.quoteSent, .consulting, .received, .completed, .canceled])
    }

    func testSelectingStatusFiltersInquiryList() {
        let viewModel = QuoteHistoryViewModel()
        viewModel.selectedStatus = .received

        XCTAssertEqual(viewModel.visibleInquiries.map(\.status), [.received])
    }

    func testAllStatusRestoresFullInquiryList() {
        let viewModel = QuoteHistoryViewModel()
        viewModel.selectedStatus = .canceled
        viewModel.selectedStatus = .all

        XCTAssertEqual(viewModel.visibleInquiries.count, 5)
    }
}
