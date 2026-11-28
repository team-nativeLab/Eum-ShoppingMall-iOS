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

    private static func failure(_ code: String, status: Int = 401) -> APIClientError {
        .httpFailure(statusCode: status, payload: APIErrorPayload(code: code, message: nil, errors: nil))
    }

    func testSubmitDoesNothingWithoutCredentials() async {
        var calls = 0
        let viewModel = LoginViewModel(login: { _, _ in calls += 1 })

        let succeeded = await viewModel.submit()

        XCTAssertFalse(succeeded)
        XCTAssertEqual(calls, 0)
        XCTAssertFalse(viewModel.showsLoginError)
    }

    func testLoginFailedShowsInlineErrorAndCountsAttempts() async {
        let viewModel = LoginViewModel(login: { _, _ in throw Self.failure("LOGIN_FAILED") })
        viewModel.email = " user@example.com "
        viewModel.password = "wrong-password"

        _ = await viewModel.submit()
        _ = await viewModel.submit()

        XCTAssertTrue(viewModel.showsLoginError)
        XCTAssertEqual(viewModel.failureCount, 2)
        XCTAssertEqual(viewModel.errorText, "이메일 또는 비밀번호가 일치하지 않습니다. (2/5회)")
        XCTAssertNil(viewModel.alertMessage)
    }

    func testLockedAndCaptchaResponsesShowServerGuidance() async {
        let locked = LoginViewModel(login: { _, _ in throw Self.failure("LOGIN_LOCKED", status: 429) })
        locked.email = "user@example.com"
        locked.password = "pw"
        _ = await locked.submit()
        XCTAssertEqual(locked.alertMessage, "로그인 시도가 많아 잠시 제한되었습니다. 10분 후 다시 시도해 주세요.")

        let captcha = LoginViewModel(login: { _, _ in throw Self.failure("CAPTCHA_REQUIRED", status: 400) })
        captcha.email = "user@example.com"
        captcha.password = "pw"
        _ = await captcha.submit()
        XCTAssertEqual(captcha.alertMessage, "여러 번 틀렸습니다. 로봇이 아님을 확인해 주세요.")
    }

    func testNetworkErrorAsksToCheckConnection() async {
        let viewModel = LoginViewModel(login: { _, _ in throw URLError(.notConnectedToInternet) })
        viewModel.email = "user@example.com"
        viewModel.password = "pw"

        _ = await viewModel.submit()

        XCTAssertEqual(viewModel.alertMessage, "네트워크 연결을 확인한 뒤 다시 시도해 주세요.")
    }

    func testSuccessfulLoginTrimsEmailAndResetsErrors() async {
        var received: (String, String)?
        let viewModel = LoginViewModel(login: { email, password in received = (email, password) })
        viewModel.email = " user@example.com "
        viewModel.password = "secret"

        let succeeded = await viewModel.submit()

        XCTAssertTrue(succeeded)
        XCTAssertEqual(received?.0, "user@example.com")
        XCTAssertEqual(received?.1, "secret")
        XCTAssertFalse(viewModel.showsLoginError)
        XCTAssertEqual(viewModel.failureCount, 0)
    }

    func testErrorPreviewStartsWithFigmaSampleValues() {
        let viewModel = LoginViewModel(initialErrorState: true)

        XCTAssertEqual(viewModel.email, "example@email.com")
        XCTAssertEqual(viewModel.password, "password")
        XCTAssertTrue(viewModel.showsLoginError)
    }
}
