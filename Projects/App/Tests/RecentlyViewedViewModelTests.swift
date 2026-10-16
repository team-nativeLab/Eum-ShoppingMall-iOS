import XCTest
@testable import EumShoppingMall

@MainActor
final class RecentlyViewedViewModelTests: XCTestCase {
    func testMockHistoryMatchesDatesAndCardStates() {
        let viewModel = RecentlyViewedViewModel()

        XCTAssertEqual(viewModel.groups.count, 2)
        XCTAssertNotEqual(viewModel.groups[0].id, viewModel.groups[1].id)
        XCTAssertEqual(viewModel.productCount, 6)
        XCTAssertTrue(viewModel.groups[0].products[1].isPriceHidden)
        XCTAssertTrue(viewModel.groups[1].products[0].isSoldOut)
    }

    func testExplicitEmptyGroupsOverrideMockSamples() {
        let viewModel = RecentlyViewedViewModel(groups: [])

        XCTAssertTrue(viewModel.groups.isEmpty)
        XCTAssertEqual(viewModel.productCount, 0)
    }

    func testRemovingLastProductRemovesItsDateGroup() {
        let viewModel = RecentlyViewedViewModel()

        viewModel.remove(productID: "recent-5")
        viewModel.remove(productID: "recent-6")

        XCTAssertEqual(viewModel.groups.count, 1)
        XCTAssertEqual(viewModel.productCount, 4)
    }

    func testRemoveAllClearsHistory() {
        let viewModel = RecentlyViewedViewModel()

        viewModel.removeAll()

        XCTAssertTrue(viewModel.groups.isEmpty)
        XCTAssertEqual(viewModel.productCount, 0)
    }
}
