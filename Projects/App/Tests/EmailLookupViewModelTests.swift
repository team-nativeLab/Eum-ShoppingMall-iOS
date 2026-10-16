import XCTest
@testable import EumShoppingMall

@MainActor
final class EmailLookupViewModelTests: XCTestCase {
    func testStartsWithFigmaValuesAndDisabledFindAction() {
        let viewModel = EmailLookupViewModel()

        XCTAssertEqual(viewModel.name, "홍길동")
        XCTAssertEqual(viewModel.phoneNumber, "010-0000-0000")
        XCTAssertEqual(viewModel.remainingTimeText, "남은 시간 02:59")
        XCTAssertFalse(viewModel.canFindEmail)
    }

    func testMockVerificationCodeEnablesLookup() {
        let viewModel = EmailLookupViewModel()
        viewModel.updateVerificationCode("123456")

        XCTAssertTrue(viewModel.canVerifyCode)
        XCTAssertTrue(viewModel.verifyCode())
        XCTAssertTrue(viewModel.canFindEmail)
        XCTAssertEqual(viewModel.findEmail(), "example@email.com")
    }

    func testVerificationCodeAcceptsOnlySixDigits() {
        let viewModel = EmailLookupViewModel()
        viewModel.updateVerificationCode("12a345678")

        XCTAssertEqual(viewModel.verificationCode, "123456")
    }

    func testChangingPhoneNumberResetsVerification() {
        let viewModel = EmailLookupViewModel()
        viewModel.updateVerificationCode("123456")
        _ = viewModel.verifyCode()

        viewModel.updatePhoneNumber("010-1111-2222")

        XCTAssertFalse(viewModel.isPhoneVerified)
        XCTAssertFalse(viewModel.canFindEmail)
    }

    func testTimerStopsAtZero() {
        let viewModel = EmailLookupViewModel()
        for _ in 0..<180 {
            viewModel.tickTimer()
        }

        XCTAssertEqual(viewModel.remainingSeconds, 0)
        XCTAssertFalse(viewModel.canVerifyCode)
    }
}
