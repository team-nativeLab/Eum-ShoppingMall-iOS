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

    func testWithdrawalUpdatesSharedHistoryItemAndKeepsSelectedFilter() {
        let viewModel = ReturnHistoryViewModel()
        viewModel.select(.returnRequest)

        let withdrawn = viewModel.markWithdrawn(id: "return-requested")

        XCTAssertEqual(withdrawn?.status, .withdrawn)
        XCTAssertEqual(viewModel.filteredItems.first?.status, .withdrawn)
        XCTAssertEqual(viewModel.selectedFilter, .returnRequest)
        XCTAssertNil(viewModel.markWithdrawn(id: "return-requested"))
    }

    func testAddingLocalRequestPrependsItToVisibleHistory() {
        let viewModel = ReturnHistoryViewModel()
        let request = ReturnHistoryItem(
            id: "return-A-2026-001",
            kind: .cancellation,
            status: .requested,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000"
        )

        viewModel.add(request)

        XCTAssertEqual(viewModel.filteredItems.first?.id, request.id)
        XCTAssertEqual(viewModel.filteredItems.count, 5)
    }

    func testAddingSubmissionsAssignsUniqueApplicationNumbers() {
        let viewModel = ReturnHistoryViewModel()
        let request = ReturnHistoryItem(
            id: "temporary",
            kind: .returnRequest,
            status: .requested,
            orderDate: "2026.10.26",
            orderNumber: "123",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000"
        )

        let first = viewModel.addSubmission(request)
        let second = viewModel.addSubmission(request)

        XCTAssertEqual(first.applicationNumber, "A-2026-001")
        XCTAssertEqual(second.applicationNumber, "A-2026-002")
        XCTAssertNotEqual(first.id, second.id)
    }
}
