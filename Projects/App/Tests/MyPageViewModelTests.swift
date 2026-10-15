import XCTest
@testable import EumShoppingMall

@MainActor
final class MyPageViewModelTests: XCTestCase {
    func testMemberContentMatchesFigmaMock() {
        let viewModel = MyPageViewModel()

        XCTAssertEqual(viewModel.memberName, "홍길동")
        XCTAssertEqual(viewModel.memberType, "사업자")
        XCTAssertEqual(viewModel.greeting, "안녕하세요!")
    }

    func testShortcutsOrderStatusAndMenuMatchFigmaInventory() {
        let viewModel = MyPageViewModel()

        XCTAssertEqual(viewModel.shortcuts.map(\.title), ["주문내역", "찜한 상품", "최근 본 상품", "쿠폰함"])
        XCTAssertEqual(viewModel.orderStatuses.map(\.title), ["입금대기", "결제완료", "배송준비", "배송중", "배송완료"])
        XCTAssertEqual(viewModel.orderStatuses.map(\.count), [0, 0, 0, 0, 0])
        XCTAssertEqual(viewModel.menuItems.count, 7)
    }
}
