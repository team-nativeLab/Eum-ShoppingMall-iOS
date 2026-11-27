import XCTest

final class InquiryParityUITests: XCTestCase {
    @MainActor
    func testContactInquiryMatchesFigmaAndOpensReceipt() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["안전맛집"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        let customerCenter = app.buttons["고객센터"]
        if !customerCenter.isHittable { app.swipeUp() }
        customerCenter.tap()
        XCTAssertTrue(app.staticTexts["고객센터"].waitForExistence(timeout: 5))
        app.buttons["1:1 문의하기"].tap()
        XCTAssertTrue(app.staticTexts["1:1 문의 내역"].waitForExistence(timeout: 5))
        app.buttons["1:1 문의하기"].tap()

        XCTAssertTrue(app.staticTexts["1:1 문의하기"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["문의 유형"].exists)
        XCTAssertTrue(app.textFields["문의 제목을 입력해 주세요"].exists)
        XCTAssertTrue(app.staticTexts["문의 내용을 입력해 주세요"].exists)
        XCTAssertTrue(app.buttons["inquiry-photo-picker"].exists)
        capture(app, name: "A43-contact-inquiry")

        app.buttons["inquiry-type-picker"].tap()
        app.buttons["상품"].tap()
        let title = app.textFields["문의 제목을 입력해 주세요"]
        title.tap()
        title.typeText("안전모 배송 문의")
        let content = app.textViews["inquiry-content"]
        content.tap()
        content.typeText("배송 일정을 확인하고 싶습니다.")
        app.buttons["문의 등록"].tap()
        XCTAssertTrue(app.staticTexts["문의가 등록됐어요"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testProductInquiryMatchesFigmaAndReachesReceipt() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["안전맛집"].waitForExistence(timeout: 10))
        app.buttons["home-tab-카테고리"].tap()
        app.buttons["개인보호장비"].tap()
        app.staticTexts["세이프가드 ABS 안전모"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["ABS 안전모 (내관 조절형)"].waitForExistence(timeout: 5))

        let inquiryButton = app.buttons["product-inquiry"]
        for _ in 0..<8 where !inquiryButton.exists { app.swipeUp() }
        XCTAssertTrue(inquiryButton.waitForExistence(timeout: 5))
        inquiryButton.tap()

        XCTAssertTrue(app.staticTexts["상품 문의하기"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["상품에 대해 궁금한 점을 입력해 주세요"].exists)
        XCTAssertFalse(app.textFields["문의 제목을 입력해 주세요"].exists)
        XCTAssertTrue(app.buttons["비밀글로 문의하기"].exists)
        capture(app, name: "A44-product-inquiry")

        let content = app.textViews["inquiry-content"]
        content.tap()
        content.typeText("블랙 색상 재고를 문의합니다.")
        app.buttons["비밀글로 문의하기"].tap()
        app.buttons["문의 등록"].tap()

        XCTAssertTrue(app.staticTexts["문의가 등록됐어요"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["답변 대기"].exists)
        capture(app, name: "A45-inquiry-complete")
    }

    @MainActor
    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
