import XCTest

final class ProductListNavigationUITests: XCTestCase {
    @MainActor
    func testHomeProductListBackReturnsToHome() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["제품 둘러보기"].tap()

        XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
        app.buttons["product-list-back"].tap()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }

    @MainActor
    func testCategoryProductListBackReturnsToCategory() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-카테고리"].tap()
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

        app.buttons["home-tab-카테고리"].tap()
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

        openProductsFromCategoryTab(app)
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

        app.buttons["home-tab-카테고리"].tap()
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

        app.buttons["제품 둘러보기"].tap()
        XCTAssertTrue(app.staticTexts["전체 제품"].waitForExistence(timeout: 5))
        app.staticTexts["세이프가드 ABS 안전모"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))

        app.buttons["product-detail-back"].tap()
        let productListBackButton = app.buttons["product-list-back"]
        XCTAssertTrue(productListBackButton.waitForExistence(timeout: 5))
        productListBackButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }

    @MainActor
    func testProductReviewAndInquiryActionsOpenTheirScreensAndReturnToDetail() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        openProductsFromCategoryTab(app)
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.staticTexts["세이프가드 ABS 안전모"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))

        let allReviewsButton = app.buttons["product-all-reviews"]
        let inquiryButton = app.buttons["product-inquiry"]
        for _ in 0..<8 where !allReviewsButton.exists || !inquiryButton.exists {
            app.swipeUp()
        }
        XCTAssertTrue(allReviewsButton.waitForExistence(timeout: 5))
        allReviewsButton.tap()
        XCTAssertTrue(app.staticTexts["상품 리뷰"].waitForExistence(timeout: 5))
        app.buttons["product-reviews-back"].tap()

        XCTAssertTrue(inquiryButton.waitForExistence(timeout: 5))
        inquiryButton.tap()
        XCTAssertTrue(app.staticTexts["상품 문의하기"].waitForExistence(timeout: 5))
        app.buttons["inquiry-compose-back"].tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testShippingDetailsOpenAndReturnToTheSameProductDetail() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        openProductsFromCategoryTab(app)
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.staticTexts["세이프가드 ABS 안전모"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))

        let shippingDetailsButton = app.buttons["product-shipping-details"]
        for _ in 0..<8 where !shippingDetailsButton.exists {
            app.swipeUp()
        }
        XCTAssertTrue(shippingDetailsButton.waitForExistence(timeout: 5))
        shippingDetailsButton.tap()

        XCTAssertTrue(app.buttons["shipping-policy-back"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["상품 배송 및 교환·반품 안내"].exists)
        app.buttons["shipping-policy-back"].tap()

        XCTAssertTrue(app.buttons["product-detail-back"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["product-shipping-details"].exists)
    }

    @MainActor
    func testRelatedProductFavoriteButtonTogglesItsState() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        openProductsFromCategoryTab(app)
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.staticTexts["세이프가드 ABS 안전모"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["브랜드명"].waitForExistence(timeout: 5))

        let favoriteButton = app.buttons["related-favorite-related-0"]
        for _ in 0..<10 where !favoriteButton.exists {
            app.swipeUp()
        }
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        XCTAssertEqual(favoriteButton.label, "찜하기")
        favoriteButton.tap()
        XCTAssertEqual(favoriteButton.label, "찜 취소")
        favoriteButton.tap()
        XCTAssertEqual(favoriteButton.label, "찜하기")
    }

    @MainActor
    func testChangingTabFromProductListClearsNestedRoute() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        openProductsFromCategoryTab(app)
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
        app.buttons["product-list-tab-장바구니"].tap()
        XCTAssertTrue(app.staticTexts["장바구니"].waitForExistence(timeout: 5))
        app.buttons["tab-홈"].tap()

        XCTAssertTrue(app.buttons["home-tab-홈"].exists)
    }

    @MainActor
    func testProductListFilterAppliesToResultsAndReturnsToList() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        openProductsFromCategoryTab(app)
        XCTAssertTrue(app.buttons["product-list-filter"].waitForExistence(timeout: 5))
        app.buttons["product-list-filter"].tap()
        XCTAssertTrue(app.buttons["product-filter-apply"].waitForExistence(timeout: 5))

        app.buttons["재고 선택"].tap()
        app.buttons["품절 상품"].tap()
        app.buttons["product-filter-apply"].tap()

        XCTAssertTrue(app.staticTexts["총 1개"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["product-list-filter"].exists)
    }

    @MainActor
    func testAddressEditorCanSearchAddressAndChooseDeliveryRequest() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))

        app.buttons["home-tab-마이"].tap()
        app.buttons["배송지 관리"].tap()
        app.buttons["배송지 추가"].tap()
        app.buttons["address-editor-search"].tap()
        XCTAssertTrue(app.buttons["address-search-select"].waitForExistence(timeout: 5))

        app.buttons["address-search-result-06164"].tap()
        app.buttons["address-search-select"].tap()
        XCTAssertTrue(app.buttons["address-editor-delivery-request"].waitForExistence(timeout: 5))

        app.buttons["address-editor-delivery-request"].tap()
        XCTAssertTrue(app.buttons["delivery-request-complete"].waitForExistence(timeout: 5))
        app.buttons["문 앞에 놓아 주세요"].tap()
        app.buttons["delivery-request-complete"].tap()

        XCTAssertTrue(app.buttons["address-editor-search"].waitForExistence(timeout: 5))
    }
    @MainActor
    private func openProductsFromCategoryTab(_ app: XCUIApplication) {
        app.buttons["home-tab-카테고리"].tap()
        XCTAssertTrue(app.staticTexts["카테고리"].waitForExistence(timeout: 5))
        app.buttons["개인보호장비"].tap()
        XCTAssertTrue(app.staticTexts["개인보호장비"].waitForExistence(timeout: 5))
    }

}
