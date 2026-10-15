import XCTest
@testable import EumShoppingMall

@MainActor
final class ReturnHistoryViewModelTests: XCTestCase {
    func testAllFilterShowsMockStatusesAndTypes() {
        let viewModel = ReturnHistoryViewModel()

        XCTAssertEqual(viewModel.filteredItems.count, 4)
        XCTAssertEqual(viewModel.filteredItems.map(\.status), [.requested, .collecting, .exchangeComplete, .rejected])
    }

    func testSelectingFilterShowsOnlyMatchingRequestKind() {
        let viewModel = ReturnHistoryViewModel()

        viewModel.select(.returnRequest)
        XCTAssertEqual(viewModel.filteredItems.map(\.kind), [.returnRequest, .returnRequest])

        viewModel.select(.cancellation)
        XCTAssertEqual(viewModel.filteredItems.map(\.status), [.rejected])
    }
}
