import Foundation

struct TermsArticle: Identifiable {
    let number: Int
    let title: String
    let includesSampleItems: Bool

    var id: Int { number }
}

struct TermsChapter: Identifiable {
    let title: String
    let articles: [TermsArticle]

    var id: String { title }
}

enum TermsDocument {
    static let effectiveDate = "0000.00.00"
    static let previousVersionNoticePrefix = "이전 약관입니다. 현재 약관은 0000.00.00부터 시행 중입니다.  "
    static let currentTermsLabel = "현재 약관 보기"
    static let articleBody = "조항 내용이 들어갑니다."
    static let itemBody = "항 내용이 들어갑니다."
    static let addendum = "이 약관은 0000년 00월 00일부터 시행합니다."

    static let chapters = [
        TermsChapter(title: "제1장 총칙", articles: [
            TermsArticle(number: 1, title: "제1조(목적)", includesSampleItems: false),
            TermsArticle(number: 2, title: "제2조(정의)", includesSampleItems: true),
            TermsArticle(number: 3, title: "제3조(약관 등의 명시와 설명 및 개정)", includesSampleItems: false),
            TermsArticle(number: 4, title: "제4조(서비스의 제공 및 변경)", includesSampleItems: false),
            TermsArticle(number: 5, title: "제5조(서비스의 중단)", includesSampleItems: false)
        ]),
        TermsChapter(title: "제2장 회원", articles: [
            TermsArticle(number: 6, title: "제6조(회원가입)", includesSampleItems: false),
            TermsArticle(number: 7, title: "제7조(사업자 회원)", includesSampleItems: false),
            TermsArticle(number: 8, title: "제8조(회원 탈퇴 및 자격 상실 등)", includesSampleItems: false),
            TermsArticle(number: 9, title: "제9조(회원에 대한 통지)", includesSampleItems: false)
        ]),
        TermsChapter(title: "제3장 구매·결제", articles: [
            TermsArticle(number: 10, title: "제10조(구매신청)", includesSampleItems: false),
            TermsArticle(number: 11, title: "제11조(계약의 성립)", includesSampleItems: false),
            TermsArticle(number: 12, title: "제12조(지급방법)", includesSampleItems: false),
            TermsArticle(number: 13, title: "제13조(가격 문의 상품과 견적 문의)", includesSampleItems: false),
            TermsArticle(number: 14, title: "제14조(세금계산서 및 현금영수증)", includesSampleItems: false)
        ]),
        TermsChapter(title: "제4장 배송·청약철회", articles: [
            TermsArticle(number: 15, title: "제15조(재화 등의 공급)", includesSampleItems: false),
            TermsArticle(number: 16, title: "제16조(환급)", includesSampleItems: false),
            TermsArticle(number: 17, title: "제17조(청약철회 등)", includesSampleItems: true),
            TermsArticle(number: 18, title: "제18조(청약철회 등의 효과)", includesSampleItems: false)
        ]),
        TermsChapter(title: "제5장 보칙", articles: [
            TermsArticle(number: 19, title: "제19조(개인정보보호)", includesSampleItems: false),
            TermsArticle(number: 20, title: "제20조(회사의 의무)", includesSampleItems: false),
            TermsArticle(number: 21, title: "제21조(회원의 아이디 및 비밀번호에 대한 의무)", includesSampleItems: false),
            TermsArticle(number: 22, title: "제22조(이용자의 의무)", includesSampleItems: false),
            TermsArticle(number: 23, title: "제23조(분쟁해결)", includesSampleItems: false),
            TermsArticle(number: 24, title: "제24조(재판권 및 준거법)", includesSampleItems: false)
        ])
    ]

    static var articleCount: Int {
        chapters.reduce(0) { $0 + $1.articles.count }
    }
}
