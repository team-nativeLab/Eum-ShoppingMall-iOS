import XCTest
@testable import EumShoppingMall

final class OrderDetailViewModelTests: XCTestCase {
    @MainActor
    func testOrderDetailUsesSelectedOrderAndCreatesProductRows() {
        let selectedOrder = OrderHistoryItem.samples[2]
        let viewModel = OrderDetailViewModel(order: selectedOrder)

        XCTAssertEqual(viewModel.order, selectedOrder)
        XCTAssertEqual(viewModel.products.count, 2)
        XCTAssertTrue(viewModel.products.allSatisfy { $0.status == selectedOrder.status })
        XCTAssertEqual(viewModel.shippingRows.count, 4)
        XCTAssertEqual(viewModel.paymentRows.count, 4)
    }
}
