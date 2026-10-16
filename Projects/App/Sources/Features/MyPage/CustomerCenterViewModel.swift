import Foundation

enum CustomerCenterFAQCategory: String, CaseIterable, Identifiable {
    case all = "전체"
    case orderPayment = "주문·결제"
    case delivery = "배송"
    case exchangeReturn = "교환·반품"
    case member = "회원"

    var id: String { rawValue }
}

struct CustomerCenterFAQ: Identifiable, Equatable {
    let id: String
    let question: String
    let category: CustomerCenterFAQCategory
    let answer: String?
}

struct CustomerCenterViewModel {
    let phoneNumber = "0000-0000"
    let operatingHours = "평일 00:00 – 00:00 (주말·공휴일 휴무)"
    let categories = CustomerCenterFAQCategory.allCases
    let expandedFAQID = "delivery-time"

    let faqs = [
        CustomerCenterFAQ(
            id: "delivery-time",
            question: "주문 후 배송까지 얼마나 걸리나요?",
            category: .delivery,
            answer: "결제 완료 후 평균 2~3일(영업일 기준) 이내 출고됩니다. 맞춤 제작 상품은 별도 안내드립니다."
        ),
        CustomerCenterFAQ(
            id: "quote-purchase",
            question: "가격 문의 상품은 어떻게 구매하나요?",
            category: .orderPayment,
            answer: nil
        ),
        CustomerCenterFAQ(
            id: "tax-invoice",
            question: "세금계산서는 어떻게 발급받나요?",
            category: .orderPayment,
            answer: nil
        ),
        CustomerCenterFAQ(
            id: "exchange-return",
            question: "교환·반품은 어떻게 신청하나요?",
            category: .exchangeReturn,
            answer: nil
        ),
        CustomerCenterFAQ(
            id: "business-member",
            question: "사업자 회원으로 전환할 수 있나요?",
            category: .member,
            answer: nil
        )
    ]
}
