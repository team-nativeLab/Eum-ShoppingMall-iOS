import XCTest
@testable import EumShoppingMall

final class CustomerCenterFAQSearchViewModelTests: XCTestCase {
    func testDeliverySearchMatchesFigmaResults() {
        let viewModel = CustomerCenterFAQSearchViewModel()

        XCTAssertEqual(viewModel.query, "배송")
        XCTAssertEqual(viewModel.resultCountTitle, "검색 결과 00건")
        XCTAssertEqual(
            viewModel.results.map(\.question),
            ["주문 후 배송까지 얼마나 걸리나요?", "배송지를 변경할 수 있나요?"]
        )
        XCTAssertEqual(viewModel.matchingResults(for: "배송").count, 2)
        XCTAssertTrue(viewModel.matchingResults(for: "검색어").isEmpty)
        XCTAssertTrue(viewModel.matchingResults(for: " ").isEmpty)
        XCTAssertEqual(
            viewModel.matchingResults(for: "변경").first?.question,
            "배송지를 변경할 수 있나요?"
        )
    }
}
