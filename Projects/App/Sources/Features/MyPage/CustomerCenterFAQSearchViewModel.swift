import Foundation

struct CustomerCenterFAQSearchResult: Identifiable, Equatable {
    let id: String
    let question: String
}

struct CustomerCenterFAQSearchViewModel {
    let query = "배송"
    let resultCountTitle = "검색 결과 00건"
    let results = [
        CustomerCenterFAQSearchResult(
            id: "delivery-time",
            question: "주문 후 배송까지 얼마나 걸리나요?"
        ),
        CustomerCenterFAQSearchResult(
            id: "delivery-address",
            question: "배송지를 변경할 수 있나요?"
        )
    ]
}
