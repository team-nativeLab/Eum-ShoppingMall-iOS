import XCTest
@testable import EumShoppingMall

@MainActor
final class CustomerCenterViewModelTests: XCTestCase {
    func testCustomerCenterMatchesFigmaContactAndFAQContent() {
        let viewModel = CustomerCenterViewModel()

        XCTAssertEqual(viewModel.phoneNumber, "0000-0000")
        XCTAssertEqual(viewModel.operatingHours, "평일 00:00 – 00:00 (주말·공휴일 휴무)")
        XCTAssertEqual(viewModel.categories.map(\.rawValue), ["전체", "주문·결제", "배송", "교환·반품", "회원"])
        XCTAssertEqual(viewModel.faqs.count, 5)
        XCTAssertEqual(viewModel.expandedFAQID, "delivery-time")
        XCTAssertEqual(viewModel.faqs.first?.question, "주문 후 배송까지 얼마나 걸리나요?")
        XCTAssertEqual(
            viewModel.faqs.first?.answer,
            "결제 완료 후 평균 2~3일(영업일 기준) 이내 출고됩니다. 맞춤 제작 상품은 별도 안내드립니다."
        )
    }
}
