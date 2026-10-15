import XCTest
@testable import EumShoppingMall

@MainActor
final class GuestMyPageViewModelTests: XCTestCase {
    func testGuestMyPageShowsThreeRecentMockProducts() {
        let viewModel = GuestMyPageViewModel()

        XCTAssertEqual(viewModel.recentProducts.count, 3)
        XCTAssertTrue(viewModel.recentProducts.allSatisfy { $0.title == "제품명" && $0.price == "₩00,000" })
    }

    func testGuestMenuContainsOnlyPublicDestinations() {
        let viewModel = GuestMyPageViewModel()

        XCTAssertEqual(viewModel.menuItems.map(\.title), ["고객센터", "공지사항"])
    }
}
