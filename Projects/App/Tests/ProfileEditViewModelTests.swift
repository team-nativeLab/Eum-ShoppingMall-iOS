import XCTest
@testable import EumShoppingMall

@MainActor
final class ProfileEditViewModelTests: XCTestCase {
    func testEditProfileStartsWithFigmaSampleValues() {
        let viewModel = ProfileEditViewModel()

        XCTAssertEqual(viewModel.email, "example@email.com")
        XCTAssertEqual(viewModel.name, "홍길동")
        XCTAssertEqual(viewModel.phoneNumber, "010-0000-0000")
        XCTAssertEqual(viewModel.businessNumber, "000-00-00000")
        XCTAssertTrue(viewModel.agreesToSMS)
        XCTAssertFalse(viewModel.agreesToEmail)
    }

    func testSaveExplainsServiceIsNotConnected() {
        let viewModel = ProfileEditViewModel()

        XCTAssertEqual(viewModel.save(), "회원 정보 저장은 계정 서비스 연동 후 이용할 수 있어요.")
    }
}
