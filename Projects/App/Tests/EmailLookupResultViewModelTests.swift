import XCTest
@testable import EumShoppingMall

@MainActor
final class EmailLookupResultViewModelTests: XCTestCase {
    func testMasksEmailAndUsesFigmaSampleDetails() {
        let viewModel = EmailLookupResultViewModel(email: "example@email.com")

        XCTAssertEqual(viewModel.maskedEmail, "ex***@email.com")
        XCTAssertEqual(viewModel.name, "홍길동")
        XCTAssertEqual(viewModel.joinedAt, "0000.00.00")
        XCTAssertEqual(viewModel.memberType, "개인 회원")
    }

    func testMalformedEmailDoesNotExposeInput() {
        XCTAssertEqual(EmailLookupResultViewModel.mask("not-an-email"), "***")
    }
}
