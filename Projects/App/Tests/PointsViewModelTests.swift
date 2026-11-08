import XCTest
@testable import EumShoppingMall

@MainActor
final class PointsViewModelTests: XCTestCase {
    func testHistoryMatchesInitialFigmaList() {
        let viewModel = PointsViewModel()

        XCTAssertEqual(viewModel.filteredHistory.count, 6)
        XCTAssertEqual(viewModel.availablePoints, "0원")
        XCTAssertEqual(viewModel.expiringPoints, "0원")
    }

    func testFiltersByEarnedUsedAndExpiredKinds() {
        let viewModel = PointsViewModel()

        viewModel.selectedFilter = .earned
        XCTAssertEqual(viewModel.filteredHistory.count, 4)
        viewModel.selectedFilter = .used
        XCTAssertEqual(viewModel.filteredHistory.map(\.title), ["주문 사용"])
        viewModel.selectedFilter = .expired
        XCTAssertEqual(viewModel.filteredHistory.map(\.title), ["기간 만료 소멸"])
    }
}
