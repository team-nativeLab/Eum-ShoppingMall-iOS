import Combine
import Foundation
import SwiftUI

enum OrderHistoryStatus: String, CaseIterable, Identifiable {
    case all = "전체"
    case awaitingPayment = "입금대기"
    case paymentComplete = "결제완료"
    case preparing = "배송준비"
    case inTransit = "배송중"
    case delivered = "배송완료"

    var id: String { rawValue }
}

/// Figma HF/Badge colors for order states (A-16, A-17, A-19s).
extension OrderHistoryStatus {
    var badgeForeground: Color {
        switch self {
        case .awaitingPayment, .paymentComplete: EUMColor.warningSwiftUI
        case .delivered: EUMColor.successSwiftUI
        default: EUMColor.text2SwiftUI
        }
    }

    var badgeBackground: Color {
        switch self {
        case .awaitingPayment, .paymentComplete: EUMColor.warningTintSwiftUI
        case .delivered: EUMColor.successTintSwiftUI
        default: .clear
        }
    }

    var badgeBorder: Color {
        switch self {
        case .preparing, .inTransit: EUMColor.lineStrongSwiftUI
        default: .clear
        }
    }
}

enum OrderHistoryPeriod: String, CaseIterable, Identifiable {
    case threeMonths = "최근 3개월"
    case sixMonths = "최근 6개월"
    case oneYear = "최근 1년"
    case all = "전체 기간"

    var id: String { rawValue }
}

struct OrderHistoryItem: Identifiable, Equatable {
    let id: String
    let status: OrderHistoryStatus
    let orderDate: String
    let orderNumber: String
    let productName: String
    let priceAndQuantity: String
    var depositDeadline: String?
    var extraProductCount: Int?

    static let samples = [
        OrderHistoryItem(
            id: "order-waiting-1",
            status: .awaitingPayment,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            depositDeadline: "입금 기한 0000.00.00까지"
        ),
        OrderHistoryItem(
            id: "order-paid-1",
            status: .paymentComplete,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            extraProductCount: 0
        ),
        OrderHistoryItem(
            id: "order-transit-1",
            status: .inTransit,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개"
        ),
        OrderHistoryItem(
            id: "order-delivered-1",
            status: .delivered,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개"
        )
    ]
}

@MainActor
final class OrderHistoryViewModel: ObservableObject {
    @Published var selectedStatus = OrderHistoryStatus.all
    @Published var selectedPeriod = OrderHistoryPeriod.threeMonths

    let orders: [OrderHistoryItem]

    init(orders: [OrderHistoryItem] = OrderHistoryItem.samples, initialStatus: OrderHistoryStatus = .all) {
        self.orders = orders
        selectedStatus = initialStatus
    }

    var filteredOrders: [OrderHistoryItem] {
        guard selectedStatus != .all else { return orders }
        return orders.filter { $0.status == selectedStatus }
    }

    func selectStatus(_ status: OrderHistoryStatus) {
        selectedStatus = status
    }

    func selectPeriod(_ period: OrderHistoryPeriod) {
        selectedPeriod = period
    }
}
