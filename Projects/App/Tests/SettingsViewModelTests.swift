import XCTest
import UserNotifications
@testable import EumShoppingMall

@MainActor
final class SettingsViewModelTests: XCTestCase {
    func testDefaultNotificationAndMarketingChoicesMatchFigma() {
        let viewModel = SettingsViewModel()

        XCTAssertTrue(viewModel.appPushEnabled)
        XCTAssertTrue(viewModel.marketingAppPushEnabled)
        XCTAssertFalse(viewModel.marketingSMSEnabled)
        XCTAssertTrue(viewModel.marketingEmailEnabled)
        XCTAssertFalse(viewModel.nightMarketingEnabled)
        XCTAssertEqual(viewModel.lastUpdatedDate, "0000.00.00")
        XCTAssertEqual(viewModel.appVersion, "0.0.0 · 최신 버전")
    }

    func testSettingsChoicesCanBeChangedIndependently() {
        let viewModel = SettingsViewModel()

        viewModel.appPushEnabled = false
        viewModel.marketingSMSEnabled = true
        viewModel.nightMarketingEnabled = true

        XCTAssertFalse(viewModel.appPushEnabled)
        XCTAssertTrue(viewModel.marketingAppPushEnabled)
        XCTAssertTrue(viewModel.marketingSMSEnabled)
        XCTAssertTrue(viewModel.marketingEmailEnabled)
        XCTAssertTrue(viewModel.nightMarketingEnabled)
    }

    func testDeviceNotificationAuthorizationAllowsActiveStatuses() {
        XCTAssertTrue(SettingsViewModel.allowsNotifications(status: .authorized))
        XCTAssertTrue(SettingsViewModel.allowsNotifications(status: .provisional))
        XCTAssertTrue(SettingsViewModel.allowsNotifications(status: .ephemeral))
        XCTAssertFalse(SettingsViewModel.allowsNotifications(status: .denied))
        XCTAssertFalse(SettingsViewModel.allowsNotifications(status: .notDetermined))
    }
}
