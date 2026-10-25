import XCTest
@testable import EumShoppingMall

final class ReturnRequestViewModelTests: XCTestCase {
    @MainActor
    func testSelectedOrderChoosesInitialRequestKind() {
        XCTAssertEqual(ReturnRequestViewModel(order: OrderHistoryItem.samples[0]).selectedKind, .cancel)
        XCTAssertEqual(ReturnRequestViewModel(order: OrderHistoryItem.samples[1]).selectedKind, .cancel)
        XCTAssertEqual(ReturnRequestViewModel(order: OrderHistoryItem.samples[2]).selectedKind, .returning)
    }

    @MainActor
    func testSelectedProductAndQuantityControlSubmissionEligibility() {
        let viewModel = ReturnRequestViewModel(order: OrderHistoryItem.samples[2])
        let firstProduct = viewModel.products[0]
        let secondProduct = viewModel.products[1]

        XCTAssertTrue(viewModel.isSelected(firstProduct))
        XCTAssertFalse(viewModel.isSelected(secondProduct))
        XCTAssertTrue(viewModel.canSubmit)

        viewModel.adjustQuantity(for: firstProduct, by: -1)
        XCTAssertFalse(viewModel.isSelected(firstProduct))
        XCTAssertFalse(viewModel.canSubmit)
        XCTAssertEqual(viewModel.submitMessage(), "반품할 상품을 선택해 주세요.")

        viewModel.adjustQuantity(for: secondProduct, by: 1)
        XCTAssertTrue(viewModel.isSelected(secondProduct))
        XCTAssertEqual(viewModel.quantity(for: secondProduct), 2)
        XCTAssertTrue(viewModel.canSubmit)
    }

    @MainActor
    func testReturnReasonAndPickupDefaultsMatchDesign() {
        let viewModel = ReturnRequestViewModel(order: OrderHistoryItem.samples[2])

        XCTAssertEqual(viewModel.selectedKind, .returning)
        XCTAssertEqual(viewModel.selectedReason, .defective)
        XCTAssertEqual(viewModel.pickupMethod, .courier)
        XCTAssertEqual(viewModel.photos.count, 2)
    }

    @MainActor
    func testEachRequestKindUpdatesTitleAndKeepsSubmissionExplicitlyUnavailable() {
        let viewModel = ReturnRequestViewModel(order: OrderHistoryItem.samples[2])

        viewModel.selectedKind = .cancel
        XCTAssertEqual(viewModel.pageTitle, "취소 신청")
        XCTAssertEqual(viewModel.submitTitle, "취소 신청하기")
        XCTAssertEqual(viewModel.submitMessage(), "취소 신청은 주문 서비스 연동 후 접수할 수 있어요.")

        viewModel.selectedKind = .exchange
        XCTAssertEqual(viewModel.pageTitle, "교환 신청")
        XCTAssertEqual(viewModel.submitTitle, "교환 신청하기")
        XCTAssertEqual(viewModel.submitMessage(), "교환 신청은 주문 서비스 연동 후 접수할 수 있어요.")

        viewModel.selectedKind = .returning
        XCTAssertEqual(viewModel.pageTitle, "반품 신청")
        XCTAssertEqual(viewModel.submitTitle, "반품 신청하기")
    }

    @MainActor
    func testLocalRequestRecordUsesSelectedOrderKindProductAndReason() {
        let viewModel = ReturnRequestViewModel(order: OrderHistoryItem.samples[2])
        viewModel.selectedKind = .exchange
        viewModel.selectedReason = .wrongItem

        let item = viewModel.makeHistoryItem(applicationNumber: "A-2026-001")

        XCTAssertEqual(item.kind, .exchange)
        XCTAssertEqual(item.status, .requested)
        XCTAssertEqual(item.orderNumber, OrderHistoryItem.samples[2].orderNumber)
        XCTAssertEqual(item.requestReason, "오배송")
        XCTAssertEqual(item.applicationNumber, "A-2026-001")
    }
}
