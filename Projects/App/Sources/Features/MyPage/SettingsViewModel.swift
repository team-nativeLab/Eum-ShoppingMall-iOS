import Combine
import Foundation
import UserNotifications

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var appPushEnabled = true
    @Published private(set) var deviceNotificationsAllowed = true
    @Published var marketingAppPushEnabled = true
    @Published var marketingSMSEnabled = false
    @Published var marketingEmailEnabled = true
    @Published var nightMarketingEnabled = false

    let lastUpdatedDate = "0000.00.00"
    let appVersion = "0.0.0 · 최신 버전"

    func refreshDeviceNotificationAuthorization() async {
        let status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        deviceNotificationsAllowed = Self.allowsNotifications(status: status)
    }

    static func allowsNotifications(status: UNAuthorizationStatus) -> Bool {
        switch status {
        case .authorized, .provisional, .ephemeral:
            true
        case .denied, .notDetermined:
            false
        @unknown default:
            false
        }
    }
}
