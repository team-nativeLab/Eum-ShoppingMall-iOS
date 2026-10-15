import XCTest
@testable import EumShoppingMall

final class AccountWithdrawalCompleteViewModelTests: XCTestCase {
    func testCompletionUsesFigmaPlaceholderDates() {
        let viewModel = AccountWithdrawalCompleteViewModel()

        XCTAssertEqual(viewModel.completion.withdrawalDate, "0000.00.00 00:00")
        XCTAssertEqual(viewModel.completion.rejoinAvailableDate, "0000.00.00 이후")
    }

    func testRetentionNoticePreservesFigmaPlaceholderPeriod() {
        let viewModel = AccountWithdrawalCompleteViewModel()

        XCTAssertTrue(viewModel.retentionNotice.contains("0년간"))
    }
}
