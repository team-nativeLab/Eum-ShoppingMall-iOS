import XCTest

final class SignUpNavigationUITests: XCTestCase {
    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testPersonalMarketingConsentInfoReturnsWithoutChangingConsent() {
        let app = XCUIApplication()
        openSignUp(in: app)
        assertMarketingConsentInfoReturns(in: app)
    }

    @MainActor
    func testBusinessMarketingConsentInfoReturnsWithoutChangingConsent() {
        let app = XCUIApplication()
        openSignUp(in: app)
        app.buttons["사업자 회원"].tap()
        assertMarketingConsentInfoReturns(in: app)
    }

    @MainActor
    private func openSignUp(in app: XCUIApplication) {
        app.launch()
        let drawerButton = app.buttons["전체 메뉴"]
        XCTAssertTrue(drawerButton.waitForExistence(timeout: 10))
        drawerButton.tap()
        app.buttons["로그아웃"].tap()
        app.buttons["로그인 / 회원가입"].tap()
        XCTAssertTrue(app.staticTexts["로그인"].waitForExistence(timeout: 10))
        app.buttons["회원가입"].tap()
        XCTAssertTrue(app.buttons["signup-marketing-consent-view"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func assertMarketingConsentInfoReturns(in app: XCUIApplication) {
        let detailsButton = app.buttons["signup-marketing-consent-view"]
        for _ in 0..<10 where !detailsButton.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(detailsButton.waitForExistence(timeout: 5))
        detailsButton.tap()

        XCTAssertTrue(app.staticTexts["수신 동의 항목과 안내 내용을 확인한 후 선택해 주세요."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["수집·이용 목적"].exists)
        XCTAssertTrue(app.staticTexts["수신 채널"].exists)
        XCTAssertTrue(app.staticTexts["보유 기간"].exists)
        XCTAssertTrue(app.staticTexts["동의 거부"].exists)
        attachScreenshot(of: app, named: "A56-marketing-consent")
        XCTAssertFalse(app.buttons["동의하기"].exists)
        app.buttons["marketing-consent-back"].tap()

        XCTAssertTrue(detailsButton.waitForExistence(timeout: 5))
        XCTAssertEqual(app.buttons["[선택] 마케팅 정보 수신 동의"].value as? String, "동의 안 함")
    }
}
