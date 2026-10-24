import Combine
import Foundation

enum ReturnHistoryFilter: String, CaseIterable, Identifiable {
    case all = "전체"
    case cancellation = "취소"
    case returnRequest = "반품"
    case exchange = "교환"

    var id: String { rawValue }
}

enum ReturnHistoryKind: String, Identifiable {
    case cancellation = "취소"
    case returnRequest = "반품"
    case exchange = "교환"

    var id: String { rawValue }
}

enum ReturnHistoryStatus: String {
    case requested = "반품요청"
    case collecting = "회수중"
    case exchangeComplete = "교환완료"
    case rejected = "반려"
}

struct ReturnHistoryItem: Identifiable, Equatable {
    let id: String
    let kind: ReturnHistoryKind
    let status: ReturnHistoryStatus
    let orderDate: String
    let orderNumber: String
    let productName: String
    let priceAndQuantity: String
    let refundAmount: String
    var rejectionReason: String?

    static let samples = [
        ReturnHistoryItem(
            id: "return-requested",
            kind: .returnRequest,
            status: .requested,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000"
        ),
        ReturnHistoryItem(
            id: "return-collecting",
            kind: .returnRequest,
            status: .collecting,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000"
        ),
        ReturnHistoryItem(
            id: "exchange-complete",
            kind: .exchange,
            status: .exchangeComplete,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000"
        ),
        ReturnHistoryItem(
            id: "cancel-rejected",
            kind: .cancellation,
            status: .rejected,
            orderDate: "0000.00.00",
            orderNumber: "0000000000",
            productName: "제품명",
            priceAndQuantity: "₩00,000 · 1개",
            refundAmount: "₩00,000",
            rejectionReason: "상품 준비가 시작되어 취소가 어렵습니다."
        )
    ]
}

@MainActor
final class ReturnHistoryViewModel: ObservableObject {
    @Published private(set) var selectedFilter: ReturnHistoryFilter = .all

    let items: [ReturnHistoryItem]

    init(items: [ReturnHistoryItem]? = nil) {
        self.items = items ?? (AccountSampleData.isEmpty ? [] : ReturnHistoryItem.samples)
    }

    var filteredItems: [ReturnHistoryItem] {
        guard selectedFilter != .all else { return items }
        return items.filter { $0.kind.rawValue == selectedFilter.rawValue }
    }

    func select(_ filter: ReturnHistoryFilter) {
        selectedFilter = filter
    }
}
