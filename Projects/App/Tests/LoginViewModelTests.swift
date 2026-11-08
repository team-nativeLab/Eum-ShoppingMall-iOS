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

    func testSubmitShowsInlineErrorOnlyWhenCredentialsArePresent() {
        let viewModel = LoginViewModel()

        viewModel.submit()
        XCTAssertFalse(viewModel.showsLoginError)

        viewModel.email = "user@example.com"
        viewModel.password = "wrong-password"
        viewModel.submit()
        XCTAssertTrue(viewModel.showsLoginError)
    }

    func testErrorPreviewStartsWithFigmaSampleValues() {
        let viewModel = LoginViewModel(initialErrorState: true)

        XCTAssertEqual(viewModel.email, "example@email.com")
        XCTAssertEqual(viewModel.password, "password")
        XCTAssertTrue(viewModel.showsLoginError)
    }
}
