import XCTest

final class SettingsNavigationUITests: XCTestCase {
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
        XCTAssertTrue(app.staticTexts["현재 앱 타깃에 등록된 외부 오픈소스 패키지가 없습니다."].waitForExistence(timeout: 5))
        app.buttons["open-source-licenses-back"].tap()

        XCTAssertTrue(app.staticTexts["설정"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["오픈소스 라이선스"].exists)
    }
}
