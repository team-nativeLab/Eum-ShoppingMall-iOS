import XCTest
@testable import EumShoppingMall

@MainActor
final class AddressSearchViewModelTests: XCTestCase {
    func testSearchFindsMockAddressByRoadNameOrPostalCode() {
        let viewModel = AddressSearchViewModel()
        viewModel.query = "영동대로"

        viewModel.search()

        XCTAssertEqual(viewModel.results.map(\.postalCode), ["06173"])
        XCTAssertEqual(viewModel.selectedResult?.address, "서울특별시 강남구 영동대로 513")
        XCTAssertNil(viewModel.noResultsMessage)
    }

    func testSearchWithoutMatchesShowsEmptyState() {
        let viewModel = AddressSearchViewModel()
        viewModel.query = "존재하지 않는 도로"

        viewModel.search()

        XCTAssertTrue(viewModel.results.isEmpty)
        XCTAssertNotNil(viewModel.noResultsMessage)
        XCTAssertNil(viewModel.selectedResult)
    }
}
