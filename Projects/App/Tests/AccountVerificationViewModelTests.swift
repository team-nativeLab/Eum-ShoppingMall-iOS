import XCTest
@testable import EumShoppingMall

@MainActor
final class AccountVerificationViewModelTests: XCTestCase {
    func testEmptyPasswordReturnsInputMessage() {
        let viewModel = AccountVerificationViewModel()

        XCTAssertEqual(viewModel.requestVerification(), "비밀번호를 입력해 주세요.")
        XCTAssertFalse(viewModel.isPasswordInvalid)
    }

    func testIncorrectPasswordShowsInlineError() {
        let viewModel = AccountVerificationViewModel()
        viewModel.password = "wrong-password"

        XCTAssertNil(viewModel.requestVerification())
        XCTAssertTrue(viewModel.isPasswordInvalid)
    }

    func testMockValidPasswordPassesAndTypingClearsPriorError() {
        let viewModel = AccountVerificationViewModel()
        viewModel.password = "wrong-password"
        _ = viewModel.requestVerification()

        viewModel.password = "password"
        viewModel.clearPasswordError()

        XCTAssertNil(viewModel.requestVerification())
        XCTAssertFalse(viewModel.isPasswordInvalid)
    }
}
