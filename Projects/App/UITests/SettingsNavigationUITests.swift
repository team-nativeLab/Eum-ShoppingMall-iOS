import XCTest

final class SettingsNavigationUITests: XCTestCase {
    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testPointsShortcutOpensPointsAndReturnsToMyPage() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        XCTAssertTrue(app.staticTexts["마이페이지"].waitForExistence(timeout: 5))
        app.buttons["적립금"].tap()

        XCTAssertTrue(app.staticTexts["사용 가능 적립금"].waitForExistence(timeout: 5))
        app.buttons["마이페이지로 돌아가기"].tap()
        XCTAssertTrue(app.staticTexts["마이페이지"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["적립금"].exists)
    }

    @MainActor
    func testOpenSourceLicensesOpenAndReturnToSettings() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        XCTAssertTrue(app.staticTexts["마이페이지"].waitForExistence(timeout: 5))
        app.buttons["설정"].tap()
        XCTAssertTrue(app.staticTexts["설정"].waitForExistence(timeout: 5))

        app.buttons["오픈소스 라이선스"].tap()
        XCTAssertTrue(app.staticTexts["목록 예시입니다. 실제 포함 라이브러리는 앱 구성에 따라 표시됩니다."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["AndroidX · 예시"].exists)
        XCTAssertTrue(app.staticTexts["Apache License 2.0"].firstMatch.exists)
        attachScreenshot(of: app, named: "A57-open-source-licenses")
        app.buttons["open-source-licenses-back"].tap()

        XCTAssertTrue(app.staticTexts["설정"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["오픈소스 라이선스"].exists)
    }

}
