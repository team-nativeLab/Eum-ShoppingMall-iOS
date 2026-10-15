import XCTest
@testable import EumShoppingMall

final class SearchResultsViewModelTests: XCTestCase {
    @MainActor
    func testLimitsMockResultsToFourAndMarksQuoteProduct() {
        let viewModel = SearchResultsViewModel(products: makeProducts(count: 6))

        XCTAssertEqual(viewModel.visibleProducts.count, 4)
        XCTAssertEqual(viewModel.visibleProducts.filter(\.isPriceHidden).count, 1)
        XCTAssertTrue(viewModel.visibleProducts.last?.isPriceHidden == true)
    }

    @MainActor
    func testPriceFilterShowsOnlyQuoteProducts() {
        let viewModel = SearchResultsViewModel(products: makeProducts(count: 4))
        viewModel.priceFilter = .quote

        XCTAssertEqual(viewModel.visibleProducts.map(\.id), ["product-3"])
    }

    @MainActor
    func testFavoriteCanBeToggled() {
        let viewModel = SearchResultsViewModel(products: makeProducts(count: 4))

        viewModel.toggleFavorite(productID: "product-0")

        XCTAssertTrue(viewModel.visibleProducts[0].isFavorite)
    }

    private func makeProducts(count: Int) -> [HomeProduct] {
        (0..<count).map { index in
            HomeProduct(
                id: "product-\(index)",
                title: "제품명",
                price: "₩00,000",
                imageName: nil,
                isFavorite: false,
                isSoldOut: false,
                isPriceHidden: false
            )
        }
    }
}
