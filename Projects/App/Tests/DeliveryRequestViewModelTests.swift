import XCTest
@testable import EumShoppingMall

@MainActor
final class DeliveryRequestViewModelTests: XCTestCase {
    func testSelectingPresetReturnsThatRequest() {
        let viewModel = DeliveryRequestViewModel(initialSelection: "선택해 주세요")

        viewModel.select("문 앞에 놓아 주세요")

        XCTAssertEqual(viewModel.selection, "문 앞에 놓아 주세요")
    }

    func testCustomRequestReplacesPresetAndIsLimitedToFiftyCharacters() {
        let viewModel = DeliveryRequestViewModel(initialSelection: "경비실에 맡겨 주세요")
        viewModel.customText = String(repeating: "가", count: 60)

        viewModel.limitCustomText()

        XCTAssertEqual(viewModel.customText.count, DeliveryRequestViewModel.customTextLimit)
        XCTAssertEqual(viewModel.selection, String(repeating: "가", count: 50))
    }

    func testInitialNoSelectionKeepsPlaceholder() {
        let viewModel = DeliveryRequestViewModel(initialSelection: "선택해 주세요")

        XCTAssertEqual(viewModel.selection, "선택해 주세요")
    }
}
