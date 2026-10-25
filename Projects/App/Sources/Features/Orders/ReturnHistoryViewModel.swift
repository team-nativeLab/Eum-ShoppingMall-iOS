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
    case withdrawn = "철회완료"
}

struct ReturnHistoryItem: Identifiable, Equatable {
    let id: String
    let kind: ReturnHistoryKind
    var status: ReturnHistoryStatus
    let orderDate: String
    let orderNumber: String
    let productName: String
    let priceAndQuantity: String
    let refundAmount: String
    var rejectionReason: String?
    var applicationNumber = "A-2026-001"
    var requestReason = "단순 변심"
    var pickupAddress = "서울특별시 강남구 테헤란로 427"
    var requestDate = "2026.10.19"

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

    @Published private(set) var items: [ReturnHistoryItem]

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

    func add(_ item: ReturnHistoryItem) {
        items.insert(item, at: 0)
    }

    func addSubmission(_ item: ReturnHistoryItem) -> ReturnHistoryItem {
        let nextNumber = (items.filter { $0.id.hasPrefix("return-A-2026-") }
            .compactMap { Int($0.applicationNumber.split(separator: "-").last ?? "") }.max() ?? 0) + 1
        let applicationNumber = String(format: "A-2026-%03d", nextNumber)
        let submittedItem = ReturnHistoryItem(
            id: "return-\(applicationNumber)",
            kind: item.kind,
            status: item.status,
            orderDate: item.orderDate,
            orderNumber: item.orderNumber,
            productName: item.productName,
            priceAndQuantity: item.priceAndQuantity,
            refundAmount: item.refundAmount,
            rejectionReason: item.rejectionReason,
            applicationNumber: applicationNumber,
            requestReason: item.requestReason,
            pickupAddress: item.pickupAddress,
            requestDate: item.requestDate
        )
        add(submittedItem)
        return submittedItem
    }

    @discardableResult
    func markWithdrawn(id: String) -> ReturnHistoryItem? {
        guard let index = items.firstIndex(where: { $0.id == id }), items[index].status == .requested else {
            return nil
        }
        items[index].status = .withdrawn
        return items[index]
    }
}
