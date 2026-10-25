import XCTest

final class ReturnFlowUITests: XCTestCase {
    @MainActor
    func testHubOrderSelectionAndAllRequestKindsReturnToSelectedOrder() {
        let app = launchHub()
        capture(app, name: "A19c-return-hub")
        app.buttons["주문/배송 조회"].tap()
        XCTAssertTrue(app.staticTexts["주문내역"].waitForExistence(timeout: 5))
        back(app)
        app.buttons["취소/반품/교환 신청"].tap()
        XCTAssertTrue(app.staticTexts["신청할 주문 선택"].waitForExistence(timeout: 5))
        capture(app, name: "A19s-order-selection")
        app.buttons["return-order-select-order-waiting-1"].tap()
        XCTAssertTrue(app.staticTexts["취소 신청"].waitForExistence(timeout: 5))
        capture(app, name: "A19a-cancel-request")
        app.buttons["취소 신청하기"].tap()
        XCTAssertTrue(app.staticTexts["신청이 접수됐어요"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["A-2026-001"].exists)
        capture(app, name: "A50-request-complete")
        app.buttons["return-request-completion-back"].tap()
        app.buttons["return-kind-교환"].tap()
        XCTAssertTrue(app.staticTexts["교환 신청"].waitForExistence(timeout: 5))
        capture(app, name: "A19b-exchange-request")
        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["교환 비용 안내"].waitForExistence(timeout: 5))
        capture(app, name: "A19b-exchange-cost")
        app.buttons["교환 신청하기"].tap()
        XCTAssertTrue(app.staticTexts["신청이 접수됐어요"].waitForExistence(timeout: 5))
        app.buttons["return-request-completion-back"].tap()
        app.buttons["return-order-select-back"]
            .coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            .tap()
        XCTAssertTrue(app.staticTexts["신청할 주문 선택"].waitForExistence(timeout: 5))
        app.buttons["return-select-filter-배송중"].tap()
        app.buttons["return-order-select-order-transit-1"].tap()
        XCTAssertTrue(app.staticTexts["반품 신청"].waitForExistence(timeout: 5))
        back(app)
        XCTAssertTrue(app.buttons["return-select-filter-배송중"].isSelected)
    }

    @MainActor
    func testHistoryFiltersRejectionDetailAndBack() {
        let app = launchHub()
        app.buttons["취소/반품 내역"].tap()
        XCTAssertTrue(app.staticTexts["취소/반품/교환 내역"].waitForExistence(timeout: 5))
        app.buttons["취소"].tap()
        capture(app, name: "A19l-cancel-filter")
        app.buttons["반려 사유 보기"].tap()
        XCTAssertTrue(app.staticTexts["신청 처리 결과"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["상품 준비가 시작되어 취소가 어렵습니다."].exists)
        capture(app, name: "A54-rejection-reason")
        app.buttons["신청 내역 보기"].tap()
        XCTAssertTrue(app.buttons["취소"].isSelected)
        app.buttons["반품"].tap()
        capture(app, name: "A19l-return-filter")
        app.buttons["신청 상세"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["신청 상세"].waitForExistence(timeout: 5))
        app.buttons["return-request-detail-back"].coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        app.buttons["교환"].tap()
        capture(app, name: "A19l-exchange-filter")
        XCTAssertTrue(app.staticTexts["교환완료"].exists)
    }

    @MainActor
    func testEmptyHistoryLinksToOrdersAndReturns() {
        let app = launchHub(empty: true)
        app.buttons["취소/반품 내역"].tap()
        XCTAssertTrue(app.staticTexts["신청 내역이 없습니다"].waitForExistence(timeout: 5))
        capture(app, name: "A19le-return-empty")
        app.buttons["return-empty-orders"].tap()
        XCTAssertTrue(app.staticTexts["주문내역"].waitForExistence(timeout: 5))
        back(app)
        XCTAssertTrue(app.staticTexts["신청 내역이 없습니다"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testWithdrawalCompletionUpdatesHistoryAndDetailWithoutServer() {
        let app = launchHub()
        app.buttons["취소/반품 내역"].tap()
        XCTAssertTrue(app.staticTexts["취소/반품/교환 내역"].waitForExistence(timeout: 5))
        app.buttons["반품"].tap()
        app.buttons["return-history-detail-return-requested"].tap()
        XCTAssertTrue(app.buttons["신청 철회"].waitForExistence(timeout: 5))
        app.buttons["신청 철회"].tap()
        XCTAssertTrue(app.buttons["철회 요청"].waitForExistence(timeout: 5))
        app.buttons["철회 요청"].tap()

        XCTAssertTrue(app.staticTexts["철회가 완료됐어요"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["A-2026-001"].exists)
        capture(app, name: "A53-withdrawal-complete")
        app.buttons["return-withdrawal-completion-history"].tap()

        let status = app.staticTexts["return-history-status-return-requested"]
        XCTAssertTrue(status.waitForExistence(timeout: 5))
        XCTAssertEqual(status.label, "철회완료")
        XCTAssertTrue(app.buttons["반품"].isSelected)
        capture(app, name: "A19l-after-withdrawal")
        app.buttons["return-history-detail-return-requested"].tap()
        XCTAssertTrue(app.staticTexts["철회 완료 · 신청이 정상적으로 취소됐습니다."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["서울특별시 강남구 테헤란로 427"].exists)
        capture(app, name: "A51-withdrawn-detail")
        app.buttons["return-request-detail-back"].tap()
        XCTAssertTrue(app.buttons["반품"].isSelected)
    }

    @MainActor
    private func launchHub(empty: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        if empty { app.launchArguments = ["-ui-test-empty-account"] }
        app.launch()
        XCTAssertTrue(app.staticTexts["이음산업건설"].waitForExistence(timeout: 10))
        app.buttons["home-tab-마이"].tap()
        let entry = app.buttons["취소·반품·교환 내역"]
        if !entry.isHittable { app.swipeUp() }
        entry.tap()
        XCTAssertTrue(app.staticTexts["취소·반품·교환"].waitForExistence(timeout: 5))
        return app
    }

    @MainActor
    private func back(_ app: XCUIApplication) {
        let matches = app.buttons.matching(identifier: "이전 화면으로 돌아가기").allElementsBoundByIndex
        guard let button = matches.first(where: { $0.isHittable }) else {
            XCTFail("활성 화면의 뒤로 버튼을 찾지 못했습니다")
            return
        }
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
