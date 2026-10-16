import XCTest
@testable import EumShoppingMall

final class OrderHistoryViewModelTests: XCTestCase {
    @MainActor
    func testOrderHistoryFiltersOrdersBySelectedStatus() {
        let viewModel = OrderHistoryViewModel()
        XCTAssertEqual(viewModel.filteredOrders.count, 4)

        viewModel.selectStatus(.inTransit)
        XCTAssertEqual(viewModel.filteredOrders.map(\.id), ["order-transit-1"])

        viewModel.selectStatus(.preparing)
        XCTAssertTrue(viewModel.filteredOrders.isEmpty)

        viewModel.selectStatus(.all)
        XCTAssertEqual(viewModel.filteredOrders.count, 4)
    }

    @MainActor
    func testOrderHistoryPeriodSelectionUpdatesVisibleValue() {
        let viewModel = OrderHistoryViewModel()
        viewModel.selectPeriod(.oneYear)
        XCTAssertEqual(viewModel.selectedPeriod, .oneYear)
    }

    @MainActor
    func testOrderStatusEntryStartsWithTheSelectedStatus() {
        let viewModel = OrderHistoryViewModel(initialStatus: .inTransit)
        XCTAssertEqual(viewModel.selectedStatus, .inTransit)
        XCTAssertEqual(viewModel.filteredOrders.map(\.id), ["order-transit-1"])
    }

}
