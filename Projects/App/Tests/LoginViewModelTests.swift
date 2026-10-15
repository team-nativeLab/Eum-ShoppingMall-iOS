import XCTest
@testable import EumShoppingMall

@MainActor
final class LoginViewModelTests: XCTestCase {
    func testLoginStaysDisabledUntilEmailAndPasswordAreEntered() {
        let viewModel = LoginViewModel()

        XCTAssertFalse(viewModel.canSubmit)

        viewModel.email = "user@example.com"
        XCTAssertFalse(viewModel.canSubmit)

        viewModel.password = "password"
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testLoginStatePreferenceCanBeToggled() {
        let viewModel = LoginViewModel()

        XCTAssertFalse(viewModel.shouldKeepSignedIn)
        viewModel.toggleKeepSignedIn()
        XCTAssertTrue(viewModel.shouldKeepSignedIn)
    }
}
