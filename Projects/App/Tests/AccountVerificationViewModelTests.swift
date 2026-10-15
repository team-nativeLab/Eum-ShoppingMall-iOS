import XCTest
@testable import EumShoppingMall

final class AccountVerificationViewModelTests: XCTestCase {
    @MainActor
    func testVerificationRequiresPasswordBeforeShowingServiceNotice() {
        let viewModel = AccountVerificationViewModel()
        XCTAssertEqual(viewModel.requestVerification(), "비밀번호를 입력해 주세요.")

        viewModel.password = "entered-password"
        XCTAssertEqual(viewModel.requestVerification(), "비밀번호 확인은 계정 서비스 연동 후 이용할 수 있어요.")
    }
}
