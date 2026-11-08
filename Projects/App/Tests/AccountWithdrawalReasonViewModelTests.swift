import XCTest
@testable import EumShoppingMall

@MainActor
final class AccountWithdrawalReasonViewModelTests: XCTestCase {
    func testStartsWithFigmaOtherReasonAndSampleValues() {
        let viewModel = AccountWithdrawalReasonViewModel()

        XCTAssertTrue(viewModel.isOtherSelected)
        XCTAssertEqual(viewModel.reasonDetailCount, 6)
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testReasonDetailIsLimitedToTwoHundredCharacters() {
        let viewModel = AccountWithdrawalReasonViewModel()
        viewModel.updateReasonDetail(String(repeating: "가", count: 205))

        XCTAssertEqual(viewModel.reasonDetailCount, 200)
    }

    func testClearingPasswordDisablesSubmission() {
        let viewModel = AccountWithdrawalReasonViewModel()
        viewModel.password = ""

        XCTAssertFalse(viewModel.canSubmit)
    }

    func testIncorrectPasswordSetsErrorState() {
        let viewModel = AccountWithdrawalReasonViewModel()
        viewModel.updatePassword("incorrect")

        XCTAssertFalse(viewModel.validatePassword())
        XCTAssertTrue(viewModel.isPasswordInvalid)
    }

    func testEditingPasswordClearsErrorState() {
        let viewModel = AccountWithdrawalReasonViewModel()
        viewModel.updatePassword("incorrect")
        _ = viewModel.validatePassword()

        viewModel.updatePassword("password1")

        XCTAssertFalse(viewModel.isPasswordInvalid)
    }

    func testMockPasswordPassesValidation() {
        let viewModel = AccountWithdrawalReasonViewModel()

        XCTAssertTrue(viewModel.validatePassword())
        XCTAssertFalse(viewModel.isPasswordInvalid)
    }
}
