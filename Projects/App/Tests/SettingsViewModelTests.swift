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

    func testTurningOffMarketingAppPushShowsFigmaSuccessToast() {
        let viewModel = SettingsViewModel()

        viewModel.setMarketingSetting(false, for: .appPush)

        XCTAssertFalse(viewModel.marketingAppPushEnabled)
        XCTAssertEqual(
            viewModel.marketingChangeToast,
            "0000.00.00 마케팅 앱 푸시 수신 거부가 처리되었습니다."
        )
        viewModel.dismissMarketingToast()
        XCTAssertNil(viewModel.marketingChangeToast)
    }

    func testOtherMarketingChoicesShowChannelAndConsentInToast() {
        let viewModel = SettingsViewModel()

        viewModel.setMarketingSetting(true, for: .sms)

        XCTAssertTrue(viewModel.marketingSMSEnabled)
        XCTAssertEqual(viewModel.marketingChangeToast, "0000.00.00 마케팅 문자(SMS) 수신 동의가 처리되었습니다.")
        viewModel.dismissMarketingToast()
    }
}
