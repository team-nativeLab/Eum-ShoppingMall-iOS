import XCTest

final class EventNavigationUITests: XCTestCase {
    @MainActor
    func testFeaturedEventMatchesFigmaAndOpensProducts() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["전체 메뉴"].tap()
        app.buttons["이벤트"].tap()

        XCTAssertTrue(app.staticTexts["진행 중인 이벤트와 지난 혜택을 확인해 보세요."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["가을맞이 안전장비 할인 · 10.10–10.31"].exists)
        XCTAssertTrue(app.staticTexts["신규 회원 웰컴 혜택 · 09.01–09.30"].exists)
        attachScreenshot(of: app, named: "A54-event-list")
        app.buttons["event-open-event-ongoing-1"].tap()

        XCTAssertTrue(app.staticTexts["이벤트 기간 · 2026.10.01–10.31"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["혜택 안내"].exists)
        XCTAssertTrue(app.staticTexts["참여 방법"].exists)
        XCTAssertTrue(app.staticTexts["유의 사항"].exists)
        attachScreenshot(of: app, named: "A55-event-detail")
        app.buttons["event-browse-products"].tap()
        XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
