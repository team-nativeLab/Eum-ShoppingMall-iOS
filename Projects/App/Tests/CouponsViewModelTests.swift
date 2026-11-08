import XCTest
@testable import EumShoppingMall

@MainActor
final class CouponsViewModelTests: XCTestCase {
    func testAvailableCouponsMatchFigmaSamples() {
        let viewModel = CouponsViewModel()

        XCTAssertEqual(viewModel.couponsForSelectedTab.count, 4)
        XCTAssertEqual(viewModel.couponsForSelectedTab.first?.remainingDays, "D-0")
        XCTAssertEqual(viewModel.couponsForSelectedTab.last?.scope, "배송비")
    }

    func testCompletedTabHasNoMockCoupons() {
        let viewModel = CouponsViewModel()

        viewModel.selectedTab = .completed

        XCTAssertTrue(viewModel.couponsForSelectedTab.isEmpty)
    }

    func testRegistrationExplainsMissingCodeAndService() {
        let viewModel = CouponsViewModel()

        XCTAssertEqual(viewModel.registerCoupon(code: "  "), "쿠폰 코드를 입력해 주세요.")
        XCTAssertEqual(viewModel.registerCoupon(code: "EUM123"), "쿠폰 등록은 서비스 연동 후 이용할 수 있어요.")
    }
}
