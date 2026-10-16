import XCTest
@testable import EumShoppingMall

final class NotificationRouteTests: XCTestCase {
    func testDeliveryNotificationOpensShippingOrdersWithoutInventingAnOrderID() {
        guard case let .orderHistory(status) = HomeModalRoute.destination(for: .delivery) else {
            return XCTFail("A delivery notification must open the shipping order list")
        }
        XCTAssertEqual(status, .inTransit)
        guard case .orderHistory(status: .all) = HomeModalRoute.destination(for: .order) else {
            return XCTFail("An order notification must open the order list")
        }
    }

    func testInquiryAndNoticeNotificationsOpenTheirPublishedLists() {
        guard case .accountCollection(.quoteHistory) = HomeModalRoute.destination(for: .quote),
              case .accountCollection(.contactHistory) = HomeModalRoute.destination(for: .contact),
              case .announcements = HomeModalRoute.destination(for: .notice) else {
            return XCTFail("Notification kinds must resolve to their corresponding published lists")
        }
    }

    @MainActor
    func testOpeningOneNotificationMarksOnlyThatNotificationRead() {
        let viewModel = NotificationsViewModel()
        viewModel.markRead("notification-delivery")
        XCTAssertFalse(viewModel.notifications[0].isUnread)
        XCTAssertTrue(viewModel.notifications[1].isUnread)
        XCTAssertEqual(viewModel.unreadCount, 1)
    }
}
