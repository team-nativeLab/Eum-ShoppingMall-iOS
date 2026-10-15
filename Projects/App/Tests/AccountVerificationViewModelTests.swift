import XCTest
@testable import EumShoppingMall

final class AccountVerificationViewModelTests: XCTestCase {
    @MainActor
    func testVerificationRequiresPasswordBeforeShowingServiceNotice() {
        let viewModel = AccountVerificationViewModel()
        XCTAssertEqual(viewModel.requestVerification(), "비밀번호를 입력해 주세요.")

        viewModel.password = "entered-password"
        XCTAssertNil(viewModel.requestVerification())
    }
}
