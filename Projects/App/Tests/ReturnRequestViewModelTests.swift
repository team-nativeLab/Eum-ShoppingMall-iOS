import XCTest
@testable import EumShoppingMall

final class ReturnRequestViewModelTests: XCTestCase {
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
}
