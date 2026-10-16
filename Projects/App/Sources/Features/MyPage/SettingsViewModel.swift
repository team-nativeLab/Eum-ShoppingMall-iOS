import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var appPushEnabled = true
    @Published var marketingAppPushEnabled = true
    @Published var marketingSMSEnabled = false
    @Published var marketingEmailEnabled = true
    @Published var nightMarketingEnabled = false

    let lastUpdatedDate = "0000.00.00"
    let appVersion = "0.0.0 · 최신 버전"
}
