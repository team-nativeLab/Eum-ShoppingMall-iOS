import Combine
import Foundation

enum NotificationKind: Equatable {
    case delivery
    case quote
    case contact
    case order
    case notice

    var title: String {
        switch self {
        case .delivery: "배송"
        case .quote: "견적 답변"
        case .contact: "문의 답변"
        case .order: "주문"
        case .notice: "공지"
        }
    }

    var iconName: String {
        switch self {
        case .delivery: "NotificationDelivery"
        case .quote: "NotificationQuote"
        case .contact: "NotificationContact"
        case .order: "NotificationOrder"
        case .notice: "NotificationNotice"
        }
    }
}

struct AppNotification: Identifiable, Equatable {
    let id: String
    let kind: NotificationKind
    let time: String
    let title: String
    let message: String
    let isToday: Bool
    var isUnread: Bool
}

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published private(set) var notifications: [AppNotification]

    init() {
        notifications = [
        AppNotification(
            id: "notification-delivery",
            kind: .delivery,
            time: "0분 전",
            title: "배송이 시작되었습니다",
            message: "주문번호 0000000000 상품이 출발했습니다.",
            isToday: true,
            isUnread: true
        ),
        AppNotification(
            id: "notification-quote",
            kind: .quote,
            time: "0분 전",
            title: "견적서가 도착했습니다",
            message: "'견적 문의 제목'에 견적서가 등록되었습니다.",
            isToday: true,
            isUnread: true
        ),
        AppNotification(
            id: "notification-contact",
            kind: .contact,
            time: "0분 전",
            title: "문의 답변이 등록되었습니다",
            message: "'문의 제목'",
            isToday: true,
            isUnread: false
        ),
        AppNotification(
            id: "notification-order",
            kind: .order,
            time: "0000.00.00",
            title: "주문이 완료되었습니다",
            message: "주문번호 0000000000",
            isToday: false,
            isUnread: false
        ),
        AppNotification(
            id: "notification-notice",
            kind: .notice,
            time: "0000.00.00",
            title: "공지 제목",
            message: "공지 내용",
            isToday: false,
            isUnread: false
        )
        ]
    }

    init(notifications: [AppNotification]) {
        self.notifications = notifications
    }

    var unreadCount: Int {
        notifications.filter(\.isUnread).count
    }

    var todayNotifications: [AppNotification] {
        notifications.filter(\.isToday)
    }

    var previousNotifications: [AppNotification] {
        notifications.filter { !$0.isToday }
    }

    func markAllRead() {
        notifications = notifications.map { notification in
            var updated = notification
            updated.isUnread = false
            return updated
        }
    }

    func markRead(_ id: String) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].isUnread = false
    }
}
