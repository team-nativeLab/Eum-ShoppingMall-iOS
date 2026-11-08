import Foundation

struct UsageGuideStep: Identifiable, Equatable {
    let number: Int
    let title: String
    let description: String

    var id: Int { number }
}

struct UsageGuideSection: Identifiable, Equatable {
    let title: String
    let includesSampleItems: Bool
    let steps: [UsageGuideStep]
    let showsCustomerCenterButton: Bool

    var id: String { title }
}

enum UsageGuideDocument {
    static let lastUpdatedDate = "0000.00.00"
    static let body = "안내 내용이 들어갑니다."
    static let itemBody = "항 내용이 들어갑니다."

    static let sections = [
        UsageGuideSection(title: "1. 회원가입 안내", includesSampleItems: true, steps: [], showsCustomerCenterButton: false),
        UsageGuideSection(title: "2. 주문·결제 안내", includesSampleItems: false, steps: [
            UsageGuideStep(number: 1, title: "상품 선택", description: "상품과 옵션을 골라 장바구니에 담습니다."),
            UsageGuideStep(number: 2, title: "주문서 작성", description: "배송지와 결제수단을 입력합니다."),
            UsageGuideStep(number: 3, title: "결제 완료", description: "결제하면 주문이 접수됩니다.")
        ], showsCustomerCenterButton: false),
        UsageGuideSection(title: "3. 가격 문의 상품과 견적 문의", includesSampleItems: false, steps: [
            UsageGuideStep(number: 1, title: "견적 문의", description: "가격 문의 상품을 담아 견적을 요청합니다."),
            UsageGuideStep(number: 2, title: "견적서 발송", description: "담당자가 확인한 뒤 견적서를 보내 드립니다."),
            UsageGuideStep(number: 3, title: "주문 진행", description: "견적을 확인한 뒤 주문을 진행합니다.")
        ], showsCustomerCenterButton: false),
        UsageGuideSection(title: "4. 배송 안내", includesSampleItems: false, steps: [], showsCustomerCenterButton: false),
        UsageGuideSection(title: "5. 교환·반품 안내", includesSampleItems: true, steps: [], showsCustomerCenterButton: false),
        UsageGuideSection(title: "6. 고객센터 안내", includesSampleItems: false, steps: [], showsCustomerCenterButton: true)
    ]
}
