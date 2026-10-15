import Combine
import Foundation

struct DeliveryTrackingEvent: Identifiable, Equatable {
    let id: String
    let title: String
    let locationAndDate: String
}

@MainActor
final class DeliveryTrackingViewModel: ObservableObject {
    let order: OrderHistoryItem
    let carrierAndNumber = "택배사명 · 송장번호 0000000000"
    let trackingNumber = "0000000000"
    let expectedArrival = "0000.00.00 도착 예정"
    let steps = ["결제완료", "상품준비", "배송시작", "배송중", "배송완료"]
    let currentStepIndex = 3
    let events = [
        DeliveryTrackingEvent(id: "event-current", title: "배송중", locationAndDate: "처리 위치 · 0000.00.00 00:00"),
        DeliveryTrackingEvent(id: "event-transit", title: "배송중", locationAndDate: "처리 위치 · 0000.00.00 00:00"),
        DeliveryTrackingEvent(id: "event-loaded", title: "간선 상차", locationAndDate: "처리 위치 · 0000.00.00 00:00"),
        DeliveryTrackingEvent(id: "event-picked-up", title: "집화 처리", locationAndDate: "처리 위치 · 0000.00.00 00:00"),
        DeliveryTrackingEvent(id: "event-received", title: "상품 인수", locationAndDate: "처리 위치 · 0000.00.00 00:00")
    ]

    init(order: OrderHistoryItem) {
        self.order = order
    }

    var productSummary: String {
        "\(order.productName) 외 0건"
    }
}
