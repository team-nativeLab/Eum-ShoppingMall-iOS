import XCTest

final class OrderHistoryNavigationUITests: XCTestCase {
    @MainActor
    func testEmptyOrderStateBrowsesProductsAndReturnsToHistory() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        XCTAssertTrue(app.staticTexts["마이페이지"].waitForExistence(timeout: 5))
        app.buttons["주문내역"].tap()
        XCTAssertTrue(app.staticTexts["주문내역"].waitForExistence(timeout: 5))

        app.buttons["order-history-filter-배송준비"].tap()
        XCTAssertTrue(app.staticTexts["주문 내역이 없습니다"].waitForExistence(timeout: 5))
        let browseProductsButton = app.buttons["order-history-browse-products"]
        XCTAssertTrue(browseProductsButton.exists)
        XCTAssertTrue(browseProductsButton.isEnabled)
        browseProductsButton.tap()

        XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
        app.buttons["product-list-back"].tap()
        XCTAssertTrue(app.staticTexts["주문 내역이 없습니다"].waitForExistence(timeout: 5))
        XCTAssertTrue(browseProductsButton.exists)
    }
}
