import XCTest
@testable import EumShoppingMall

final class AccountWithdrawalBlockedViewModelTests: XCTestCase {
    func testBlockedMessageIncludesCurrentOrderCount() {
        let viewModel = AccountWithdrawalBlockedViewModel(activeOrderCount: 3)

        XCTAssertEqual(
            viewModel.blockedMessage,
            "진행 중인 주문이 3건 있어 지금은 탈퇴할 수 없습니다. 배송·반품이 끝난 뒤 다시 시도해 주세요."
        )
    }

    func testWithdrawalNoticesPreserveFigmaPlaceholderPeriods() {
        let viewModel = AccountWithdrawalBlockedViewModel(activeOrderCount: 1)

        XCTAssertTrue(viewModel.notices[2].contains("기록은 0년"))
        XCTAssertTrue(viewModel.notices[3].contains("0일"))
    }
}
