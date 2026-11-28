import XCTest

final class CategoryParityUITests: XCTestCase {
    @MainActor
    func testCategoryDirectoryMatchesFigmaAndOpensCategoryProducts() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["안전맛집"].waitForExistence(timeout: 10))
        app.buttons["home-tab-카테고리"].tap()

        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["제품"].exists)
        XCTAssertTrue(app.buttons["브랜드"].exists)
        XCTAssertTrue(app.buttons["전체 제품 보기"].exists)
        XCTAssertTrue(app.buttons["개인보호장비"].exists)
        capture(app)

        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
    }

    @MainActor
    private func capture(_ app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "A03-category-directory"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
