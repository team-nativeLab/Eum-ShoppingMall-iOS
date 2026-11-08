import XCTest

final class AccountEmptyStateUITests: XCTestCase {
    @MainActor
    func testEmptyShoppingScreensBrowseAndReturn() {
        let app = launchEmptyAccount()
        let screens = [
            ("최근 본 상품", "최근 본 상품이 없습니다", "recent-empty-browse", "recent-back"),
            ("쿠폰함", "사용 가능한 쿠폰이 없습니다", "coupons-empty-browse", "coupons-back"),
            ("적립금", "적립 내역이 없습니다", "points-empty-browse", "points-back")
        ]
        for (screen, title, action, backIdentifier) in screens {
            app.buttons[screen].tap()
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 5))
            capture(app, name: screen)
            app.buttons[action].tap()
            XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
            app.buttons["product-list-back"].tap()
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 5))
            tapBack(app, identifier: backIdentifier)
        }
    }

    @MainActor
    func testEmptyAddressesAndQuotesOpenFormsAndReturn() {
        let app = launchEmptyAccount()
        app.buttons["배송지 관리"].tap()
        XCTAssertTrue(app.staticTexts["등록된 배송지가 없습니다"].waitForExistence(timeout: 5))
        capture(app, name: "배송지 빈 상태")
        app.buttons["배송지 추가"].tap()
        XCTAssertTrue(app.staticTexts["배송지 추가"].waitForExistence(timeout: 5))
        tapBack(app, identifier: "address-editor-back")
        XCTAssertTrue(app.staticTexts["등록된 배송지가 없습니다"].waitForExistence(timeout: 5))
        tapBack(app, identifier: "addresses-back")
        if !app.buttons["견적 문의 내역"].isHittable { app.swipeUp() }
        app.buttons["견적 문의 내역"].tap()
        XCTAssertTrue(app.staticTexts["견적 문의 내역이 없습니다"].waitForExistence(timeout: 5))
        capture(app, name: "견적 문의 빈 상태")
        app.buttons["새 견적 문의"].tap()
        XCTAssertTrue(app.staticTexts["견적 문의"].waitForExistence(timeout: 5))
        tapBack(app, identifier: "quote-inquiry-back")
        XCTAssertTrue(app.staticTexts["견적 문의 내역이 없습니다"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testClearRecentlyViewedShowsEmptyState() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        app.buttons["최근 본 상품"].tap()
        app.buttons["전체 삭제"].tap()
        XCTAssertTrue(app.staticTexts["최근 본 상품이 없습니다"].waitForExistence(timeout: 5))
        app.buttons["recent-empty-browse"].tap()
        app.buttons["product-list-back"].tap()
        XCTAssertTrue(app.staticTexts["최근 본 상품이 없습니다"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func launchEmptyAccount() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-test-empty-account"]
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        return app
    }

    @MainActor
    private func tapBack(_ app: XCUIApplication, identifier: String) {
        let button = app.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        XCTAssertGreaterThanOrEqual(button.frame.width, 44)
        button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    @MainActor
    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
