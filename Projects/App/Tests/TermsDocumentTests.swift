import XCTest
@testable import EumShoppingMall

final class TermsDocumentTests: XCTestCase {
    func testCurrentDocumentContainsTwentyFourArticlesAcrossFiveChapters() {
        XCTAssertEqual(TermsDocument.chapters.count, 5)
        XCTAssertEqual(TermsDocument.articleCount, 24)
        XCTAssertEqual(TermsDocument.chapters.flatMap(\.articles).map(\.number), Array(1...24))
    }

    func testArticleTitlesMatchTheDesignedDocumentStructure() {
        XCTAssertEqual(TermsDocument.chapters.map(\.title), [
            "제1장 총칙",
            "제2장 회원",
            "제3장 구매·결제",
            "제4장 배송·청약철회",
            "제5장 보칙"
        ])
        XCTAssertEqual(TermsDocument.chapters[0].articles[1].title, "제2조(정의)")
        XCTAssertEqual(TermsDocument.chapters[3].articles[2].title, "제17조(청약철회 등)")
    }

    func testSampleArticleAndAddendumCopyIsPreserved() {
        XCTAssertEqual(TermsDocument.articleBody, "조항 내용이 들어갑니다.")
        XCTAssertEqual(TermsDocument.itemBody, "항 내용이 들어갑니다.")
        XCTAssertEqual(TermsDocument.addendum, "이 약관은 0000년 00월 00일부터 시행합니다.")
        XCTAssertEqual(
            TermsDocument.chapters.flatMap(\.articles).filter(\.includesSampleItems).map(\.number),
            [2, 17]
        )
    }

    func testPreviousTermsNoticeCopyIsPreserved() {
        XCTAssertEqual(
            TermsDocument.previousVersionNoticePrefix + TermsDocument.currentTermsLabel,
            "이전 약관입니다. 현재 약관은 0000.00.00부터 시행 중입니다.  현재 약관 보기"
        )
    }
}
