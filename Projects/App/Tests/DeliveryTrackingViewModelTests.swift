import XCTest
@testable import EumShoppingMall

final class DeliveryTrackingViewModelTests: XCTestCase {
    @MainActor
    func testTrackingDetailsExposeExpectedProgressAndEvents() {
        let order = OrderHistoryItem.samples[2]
        let viewModel = DeliveryTrackingViewModel(order: order)

        XCTAssertEqual(viewModel.order, order)
        XCTAssertEqual(viewModel.currentStepIndex, 3)
        XCTAssertEqual(viewModel.steps[viewModel.currentStepIndex], "배송중")
        XCTAssertEqual(viewModel.events.count, 5)
        XCTAssertEqual(viewModel.productSummary, "제품명 외 0건")
    }
}
