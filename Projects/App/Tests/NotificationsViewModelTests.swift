import XCTest
@testable import EumShoppingMall

@MainActor
final class NotificationsViewModelTests: XCTestCase {
    func testNotificationSectionsSplitAndPreserveSourceOrder() {
        let notifications = [
            notification("today-1", isToday: true),
            notification("previous-1", isToday: false),
            notification("today-2", isToday: true)
        ]
        let viewModel = NotificationsViewModel(notifications: notifications)

        let sections = viewModel.notificationSections

        XCTAssertEqual(sections.today.map(\.id), ["today-1", "today-2"])
        XCTAssertEqual(sections.previous.map(\.id), ["previous-1"])
    }

    private func notification(_ id: String, isToday: Bool) -> AppNotification {
        AppNotification(
            id: id,
            kind: .notice,
            time: "테스트",
            title: id,
            message: "테스트 알림",
            isToday: isToday,
            isUnread: false
        )
    }
}
