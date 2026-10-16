import XCTest

final class ProductListNavigationUITests: XCTestCase {
    @MainActor
    func testHomeProductListBackReturnsToHome() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["개인보호장비"].tap()

        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.buttons["product-list-back"].tap()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["개인보호장비"].exists)
        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }

    @MainActor
    func testCategoryProductListBackReturnsToCategory() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["카테고리"].tap()
        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))

        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.buttons["product-list-back"].tap()

        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["개인보호장비"].exists)
        XCTAssertTrue(app.buttons["category-search"].exists)
    }

    @MainActor
    func testContextualSearchBackReturnsToCategory() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["카테고리"].tap()
        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        app.buttons["category-search"].tap()

        XCTAssertTrue(app.staticTexts["최근 검색어"].waitForExistence(timeout: 5))
        app.buttons["search-back"].tap()

        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["category-search"].exists)
    }

    @MainActor
    func testProductListSearchBackPreservesProductList() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.buttons["product-list-search"].tap()
        XCTAssertTrue(app.staticTexts["최근 검색어"].waitForExistence(timeout: 5))
        app.buttons["search-back"].tap()

        XCTAssertTrue(app.buttons["product-list-back"].exists)
        XCTAssertTrue(app.buttons["product-list-search"].exists)
    }

    @MainActor
    func testSearchTabBackReturnsToCategoryTab() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["카테고리"].tap()
        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        app.buttons["category-tab-검색"].tap()
        XCTAssertTrue(app.staticTexts["최근 검색어"].waitForExistence(timeout: 5))
        app.buttons["search-back"].tap()

        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["category-search"].exists)
    }

    @MainActor
    func testProductDetailBackReturnsThroughListToHome() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.staticTexts["제품명"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))

        app.buttons["product-detail-back"].tap()
        let productListBackButton = app.buttons["product-list-back"]
        XCTAssertTrue(productListBackButton.waitForExistence(timeout: 5))
        productListBackButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }

    @MainActor
    func testChangingTabFromProductListClearsNestedRoute() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.buttons["product-list-tab-장바구니"].tap()
        XCTAssertTrue(app.staticTexts["장바구니"].waitForExistence(timeout: 5))
        app.buttons["tab-홈"].tap()

        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }
}
