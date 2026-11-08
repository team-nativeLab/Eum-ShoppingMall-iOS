import XCTest
@testable import EumShoppingMall

@MainActor
final class AppDrawerViewModelTests: XCTestCase {
    func testDrawerBrandAndMemberSummaryMatchFigma() {
        let viewModel = AppDrawerViewModel()

        XCTAssertEqual(viewModel.brandTitle, "이음산업건설")
        XCTAssertEqual(viewModel.tagline, "사람이 있는 곳에, 더 안전한 내일을.")
        XCTAssertEqual(viewModel.memberName, "홍길동님")
    }

    func testDrawerDestinationsMatchFigmaOrder() {
        let viewModel = AppDrawerViewModel()

        XCTAssertEqual(viewModel.destinations.map(\.title), [
            "이벤트",
            "맞춤 제작·견적 문의",
            "고객지원",
            "공지사항",
            "회사소개"
        ])
    }
}
