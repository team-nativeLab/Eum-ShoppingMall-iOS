import XCTest
@testable import EumShoppingMall

@MainActor
final class AccountWithdrawalNoticeViewModelTests: XCTestCase {
    func testAgreementStartsUnchecked() {
        let viewModel = AccountWithdrawalNoticeViewModel()

        XCTAssertFalse(viewModel.hasAgreedToWithdrawal)
    }

    func testWithdrawalNoticesPreserveFigmaPlaceholderPeriods() {
        let viewModel = AccountWithdrawalNoticeViewModel()

        XCTAssertTrue(viewModel.notices[2].contains("0년"))
        XCTAssertTrue(viewModel.notices[3].contains("0일"))
    }
}
