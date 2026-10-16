import Combine
import Foundation

struct QuoteDetailProduct: Identifiable, Equatable {
    let id: String
    let name: String
    let quantity: Int
}

@MainActor
final class QuoteDetailViewModel: ObservableObject {
    let inquiry: QuoteInquiryRecord
    let response = "담당자 답변 내용"
    let amount = "₩00,000"
    let validity = "0000.00.00까지"
    let manager = "홍길동 · 0000-0000"
    let company = "회사명"
    let contact = "010-0000-0000"
    let email = "example@email.com"
    let desiredDate = "0000.00.00"
    let deliveryAddress = "(00000) 주소"
    let requestDetails = "요청 내용"
    let quoteFileName = "견적서.pdf"
    let requestFileName = "첨부파일.pdf"

    let products = [
        QuoteDetailProduct(id: "product-1", name: "제품명", quantity: 0),
        QuoteDetailProduct(id: "product-2", name: "제품명", quantity: 0)
    ]

    let stepTitles = ["접수", "상담중", "견적 발송", "완료"]

    init(inquiry: QuoteInquiryRecord) {
        self.inquiry = inquiry
    }

    var currentStepIndex: Int {
        switch inquiry.status {
        case .received: 0
        case .consulting: 1
        case .quoteSent: 2
        case .completed, .canceled: 3
        case .all: 0
        }
    }
}
