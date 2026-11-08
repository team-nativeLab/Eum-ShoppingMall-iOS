import XCTest

final class FavoritesNavigationUITests: XCTestCase {
    @MainActor
    func testRemovingAllFavoritesBrowsesProductsAndReturnsToEmptyState() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        app.buttons["찜한 상품"].tap()
        for index in 1...6 {
            let removeButton = app.buttons["favorite-remove-favorite-\(index)"]
            XCTAssertTrue(removeButton.waitForExistence(timeout: 5))
            if !removeButton.isHittable { app.swipeUp() }
            removeButton.tap()
        }
        XCTAssertTrue(app.staticTexts["찜한 상품이 없습니다"].waitForExistence(timeout: 5))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "A20e-favorites-empty"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        let browseButton = app.buttons["favorites-browse-products"]
        XCTAssertTrue(browseButton.isEnabled)
        browseButton.tap()
        XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
        app.buttons["product-list-back"].tap()
        XCTAssertTrue(app.staticTexts["찜한 상품이 없습니다"].waitForExistence(timeout: 5))
        XCTAssertTrue(browseButton.exists)
    }
}
