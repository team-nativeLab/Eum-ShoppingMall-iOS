import XCTest

final class LoginParityUITests: XCTestCase {
    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLoginShowsFormWithoutNoticeAndInlineErrorAfterSubmit() {
        let app = XCUIApplication()
        app.launch()
        let drawerButton = app.buttons["전체 메뉴"]
        XCTAssertTrue(drawerButton.waitForExistence(timeout: 10))
        drawerButton.tap()
        app.buttons["로그아웃"].tap()
        app.buttons["로그인 / 회원가입"].tap()
        XCTAssertTrue(app.staticTexts["안전맛집"].waitForExistence(timeout: 10))

        XCTAssertFalse(app.staticTexts["로그인 후 이용할 수 있습니다."].exists)
        attachScreenshot(of: app, named: "A13-login")

        let emailField = app.textFields["이메일"]
        emailField.tap()
        emailField.typeText("example@email.com")
        let passwordField = app.secureTextFields["비밀번호"]
        passwordField.tap()
        passwordField.typeText("password")
        app.staticTexts["안전맛집"].tap()
        app.buttons["로그인"].firstMatch.tap()

        XCTAssertTrue(app.staticTexts["이메일 또는 비밀번호가 일치하지 않습니다. (0/5회)"].waitForExistence(timeout: 5))
        // iOS excludes secure-entry glyphs from screenshots, so verify masking through the value.
        XCTAssertEqual(passwordField.value as? String, String(repeating: "•", count: 8))
        XCTAssertTrue(app.buttons["비밀번호 표시"].exists)
        attachScreenshot(of: app, named: "A13e-login-error")
    }
}
