import XCTest

final class SignUpNavigationUITests: XCTestCase {
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

        XCTAssertTrue(app.staticTexts["수신 목적, 채널, 대상 정보와 철회 방법에 대한 승인 문구가 제공되지 않았습니다."].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["동의하기"].exists)
        app.buttons["signup-marketing-consent-back"].tap()

        XCTAssertTrue(detailsButton.waitForExistence(timeout: 5))
        XCTAssertEqual(app.buttons["[선택] 마케팅 정보 수신 동의"].value as? String, "동의 안 함")
    }
}
