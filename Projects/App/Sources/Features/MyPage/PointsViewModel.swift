import Combine
import Foundation

enum PointsHistoryFilter: String, CaseIterable, Identifiable {
    case all = "전체"
    case earned = "적립"
    case used = "사용"
    case expired = "소멸"

    var id: String { rawValue }
}

struct PointsHistoryItem: Identifiable {
    enum Kind: Equatable {
        case earned
        case used
        case expired
    }

    let id: String
    let title: String
    let date: String
    let amount: String
    let expiration: String?
    let kind: Kind
}

@MainActor
final class PointsViewModel: ObservableObject {
    @Published var selectedFilter = PointsHistoryFilter.all

    let availablePoints = "0원"
    let expiringPoints = "0원"

    let history = [
        PointsHistoryItem(
            id: "points-1", title: "주문 적립", date: "0000.00.00 · 주문번호 0000000000",
            amount: "+0원", expiration: "만료 0000.00.00", kind: .earned
        ),
        PointsHistoryItem(
            id: "points-2", title: "주문 사용", date: "0000.00.00 · 주문번호 0000000000",
            amount: "-0원", expiration: nil, kind: .used
        ),
        PointsHistoryItem(
            id: "points-3", title: "이벤트 적립", date: "0000.00.00 · 주문번호 0000000000",
            amount: "+0원", expiration: "만료 0000.00.00", kind: .earned
        ),
        PointsHistoryItem(
            id: "points-4", title: "기간 만료 소멸", date: "0000.00.00 · 주문번호 0000000000",
            amount: "-0원", expiration: nil, kind: .expired
        ),
        PointsHistoryItem(
            id: "points-5", title: "주문 적립", date: "0000.00.00 · 주문번호 0000000000",
            amount: "+0원", expiration: "만료 0000.00.00", kind: .earned
        ),
        PointsHistoryItem(
            id: "points-6", title: "주문 취소 환원", date: "0000.00.00 · 주문번호 0000000000",
            amount: "+0원", expiration: "만료 0000.00.00", kind: .earned
        )
    ]

    var filteredHistory: [PointsHistoryItem] {
        switch selectedFilter {
        case .all:
            history
        case .earned:
            history.filter { $0.kind == .earned }
        case .used:
            history.filter { $0.kind == .used }
        case .expired:
            history.filter { $0.kind == .expired }
        }
    }
}
