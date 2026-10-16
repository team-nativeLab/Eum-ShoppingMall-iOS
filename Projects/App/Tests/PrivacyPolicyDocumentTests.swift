import XCTest
@testable import EumShoppingMall

final class PrivacyPolicyDocumentTests: XCTestCase {
    func testDocumentContainsTwelveDesignedSectionsInOrder() {
        XCTAssertEqual(PrivacyPolicyDocument.sections.count, 12)
        XCTAssertEqual(PrivacyPolicyDocument.sections.first?.title, "1. 개인정보의 처리 목적")
        XCTAssertEqual(PrivacyPolicyDocument.sections.last?.title, "12. 개인정보 처리방침의 변경")
    }

    func testSampleItemSectionsMatchTheDesignedDocument() {
        XCTAssertEqual(
            PrivacyPolicyDocument.sections.filter(\.includesSampleItems).map(\.title),
            ["2. 처리하는 개인정보의 항목", "3. 개인정보의 처리 및 보유 기간"]
        )
    }

    func testDetailCardsContainTheDesignedRowsAndValues() {
        let sectionsWithCards = PrivacyPolicyDocument.sections.filter { !$0.detailRows.isEmpty }
        XCTAssertEqual(sectionsWithCards.map(\.title), [
            "4. 개인정보의 제3자 제공",
            "5. 개인정보 처리업무의 위탁",
            "10. 개인정보 보호책임자"
        ])
        XCTAssertEqual(sectionsWithCards.map { $0.detailRows.count }, [4, 4, 4])
        XCTAssertEqual(sectionsWithCards[2].detailRows.map(\.value), ["000", "000", "0000-0000", "000@000"])
        XCTAssertTrue(sectionsWithCards[2].usesSubtleCard)
    }
}
