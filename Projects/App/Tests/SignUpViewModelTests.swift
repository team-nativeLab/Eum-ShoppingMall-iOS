import XCTest
@testable import EumShoppingMall

final class SignUpViewModelTests: XCTestCase {
    @MainActor
    func testSignupRequiresValidFieldsAndRequiredAgreements() {
        let viewModel = SignUpViewModel()
        viewModel.email = "member@example.com"
        viewModel.password = "password1"
        viewModel.passwordConfirmation = "password1"
        viewModel.name = "홍길동"
        viewModel.phoneNumber = "01012345678"
        viewModel.verificationCode = "123456"
        XCTAssertTrue(viewModel.markEmailChecked())
        XCTAssertFalse(viewModel.canSubmit)

        XCTAssertTrue(viewModel.verifyPhoneCode())
        viewModel.toggleTerms()
        viewModel.togglePrivacy()
        XCTAssertTrue(viewModel.canSubmit)
    }

    @MainActor
    func testSignupRejectsInvalidPasswordAndPhoneCode() {
        let viewModel = SignUpViewModel()
        viewModel.password = "short"
        viewModel.verificationCode = "000000"

        XCTAssertFalse(viewModel.passwordIsValid)
        XCTAssertFalse(viewModel.verifyPhoneCode())
        XCTAssertFalse(viewModel.canSubmit)
    }

    @MainActor
    func testChangingEmailOrPhoneClearsMockVerification() {
        let viewModel = SignUpViewModel()
        viewModel.email = "member@example.com"
        XCTAssertTrue(viewModel.markEmailChecked())
        viewModel.email = "updated@example.com"
        XCTAssertFalse(viewModel.isEmailChecked)

        viewModel.phoneNumber = "01012345678"
        viewModel.verificationCode = "123456"
        XCTAssertTrue(viewModel.verifyPhoneCode())
        viewModel.phoneNumber = "01098765432"
        XCTAssertFalse(viewModel.isPhoneVerified)
    }

    @MainActor
    func testAllAgreementToggleControlsOptionalAndRequiredAgreements() {
        let viewModel = SignUpViewModel()

        viewModel.toggleAllAgreements()
        XCTAssertTrue(viewModel.agreedToTerms)
        XCTAssertTrue(viewModel.agreedToPrivacy)
        XCTAssertTrue(viewModel.agreedToMarketing)

        viewModel.toggleAllAgreements()
        XCTAssertFalse(viewModel.agreedToTerms)
        XCTAssertFalse(viewModel.agreedToPrivacy)
        XCTAssertFalse(viewModel.agreedToMarketing)
    }
}
