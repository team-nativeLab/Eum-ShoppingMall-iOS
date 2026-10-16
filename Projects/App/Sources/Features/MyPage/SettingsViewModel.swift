import Combine
import Foundation
import UserNotifications

@MainActor
final class SettingsViewModel: ObservableObject {
    enum MarketingChannel: String, CaseIterable {
        case appPush = "앱 푸시"
        case sms = "문자(SMS)"
        case email = "이메일"
        case nightBenefits = "야간 혜택 알림"
    }

    @Published var appPushEnabled = true
    @Published private(set) var deviceNotificationsAllowed = true
    @Published var marketingAppPushEnabled = true
    @Published var marketingSMSEnabled = false
    @Published var marketingEmailEnabled = true
    @Published var nightMarketingEnabled = false
    @Published private(set) var marketingChangeToast: String?

    private var toastDismissTask: Task<Void, Never>?

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

    func marketingSetting(for channel: MarketingChannel) -> Bool {
        switch channel {
        case .appPush: marketingAppPushEnabled
        case .sms: marketingSMSEnabled
        case .email: marketingEmailEnabled
        case .nightBenefits: nightMarketingEnabled
        }
    }

    func setMarketingSetting(_ isEnabled: Bool, for channel: MarketingChannel) {
        guard marketingSetting(for: channel) != isEnabled else { return }

        switch channel {
        case .appPush: marketingAppPushEnabled = isEnabled
        case .sms: marketingSMSEnabled = isEnabled
        case .email: marketingEmailEnabled = isEnabled
        case .nightBenefits: nightMarketingEnabled = isEnabled
        }

        let decision = isEnabled ? "동의" : "거부"
        showMarketingToast("\(lastUpdatedDate) 마케팅 \(channel.rawValue) 수신 \(decision)가 처리되었습니다.")
    }

    func dismissMarketingToast() {
        toastDismissTask?.cancel()
        toastDismissTask = nil
        marketingChangeToast = nil
    }

    private func showMarketingToast(_ message: String) {
        toastDismissTask?.cancel()
        marketingChangeToast = message
        toastDismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            guard !Task.isCancelled else { return }
            self?.marketingChangeToast = nil
        }
    }
}
