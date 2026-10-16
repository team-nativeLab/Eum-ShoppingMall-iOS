import XCTest
@testable import EumShoppingMall

final class UsageGuideDocumentTests: XCTestCase {
    func testDocumentContainsSixDesignedSectionsInOrder() {
        XCTAssertEqual(UsageGuideDocument.sections.map(\.title), [
            "1. 회원가입 안내",
            "2. 주문·결제 안내",
            "3. 가격 문의 상품과 견적 문의",
            "4. 배송 안내",
            "5. 교환·반품 안내",
            "6. 고객센터 안내"
        ])
    }

    func testOrderAndEstimateSectionsContainTheirDesignedSteps() {
        XCTAssertEqual(UsageGuideDocument.sections[1].steps.map(\.title), ["상품 선택", "주문서 작성", "결제 완료"])
        XCTAssertEqual(UsageGuideDocument.sections[1].steps.map(\.description), [
            "상품과 옵션을 골라 장바구니에 담습니다.",
            "배송지와 결제수단을 입력합니다.",
            "결제하면 주문이 접수됩니다."
        ])
        XCTAssertEqual(UsageGuideDocument.sections[2].steps.map(\.title), ["견적 문의", "견적서 발송", "주문 진행"])
        XCTAssertEqual(UsageGuideDocument.sections[2].steps.map(\.number), [1, 2, 3])
    }

    func testSampleItemAndCustomerCenterSectionsMatchTheDesign() {
        XCTAssertEqual(
            UsageGuideDocument.sections.filter(\.includesSampleItems).map(\.title),
            ["1. 회원가입 안내", "5. 교환·반품 안내"]
        )
        XCTAssertEqual(UsageGuideDocument.sections.filter(\.showsCustomerCenterButton).map(\.title), ["6. 고객센터 안내"])
    }
}
