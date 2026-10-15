import Combine
import Foundation

struct OrderDetailProduct: Identifiable, Equatable {
    let id: String
    let name: String
    let status: OrderHistoryStatus
    let option: String
    let priceAndQuantity: String
}

struct OrderDetailRow: Identifiable, Equatable {
    let title: String
    let value: String

    var id: String { title }
}

@MainActor
final class OrderDetailViewModel: ObservableObject {
    let order: OrderHistoryItem
    let products: [OrderDetailProduct]
    let shippingRows = [
        OrderDetailRow(title: "받는 분", value: "홍길동"),
        OrderDetailRow(title: "연락처", value: "010-0000-0000"),
        OrderDetailRow(title: "주소", value: "(00000) 주소 상세주소"),
        OrderDetailRow(title: "요청사항", value: "배송 요청사항")
    ]
    let paymentRows = [
        OrderDetailRow(title: "상품 금액", value: "₩00,000"),
        OrderDetailRow(title: "배송비", value: "₩0"),
        OrderDetailRow(title: "쿠폰 할인", value: "-₩0"),
        OrderDetailRow(title: "적립금 사용", value: "-0원")
    ]
    let totalPaid = "₩00,000"
    let paymentMethod = "카드명"
    let expectedPoints = "0원"

    init(order: OrderHistoryItem) {
        self.order = order
        products = [
            OrderDetailProduct(
                id: "\(order.id)-product-1",
                name: order.productName,
                status: order.status,
                option: "옵션명",
                priceAndQuantity: "₩00,000 · 1개"
            ),
            OrderDetailProduct(
                id: "\(order.id)-product-2",
                name: order.productName,
                status: order.status,
                option: "옵션명",
                priceAndQuantity: "₩00,000 · 1개"
            )
        ]
    }
}
