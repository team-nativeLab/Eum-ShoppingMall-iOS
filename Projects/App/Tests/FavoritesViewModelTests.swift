import XCTest
@testable import EumShoppingMall

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    func testMockFavoritesMatchVisibleFigmaProductStates() {
        let viewModel = FavoritesViewModel()

        XCTAssertEqual(viewModel.products.count, 6)
        XCTAssertEqual(viewModel.products.filter(\.isPriceHidden).count, 2)
        XCTAssertEqual(viewModel.products.filter(\.isSoldOut).count, 2)
    }

    func testExplicitEmptyProductsOverrideMockSamples() {
        let viewModel = FavoritesViewModel(products: [])

        XCTAssertTrue(viewModel.products.isEmpty)
    }

    func testRemovingFavoriteUpdatesCountAndSelection() {
        let viewModel = FavoritesViewModel()
        viewModel.toggleEditing()
        viewModel.toggleSelection(productID: "favorite-1")

        viewModel.removeFavorite(productID: "favorite-1")

        XCTAssertEqual(viewModel.products.count, 5)
        XCTAssertEqual(viewModel.selectedCount, 0)
    }

    func testRemovingSelectedProductsExitsEditMode() {
        let viewModel = FavoritesViewModel()
        viewModel.toggleEditing()
        viewModel.toggleSelection(productID: "favorite-2")

        viewModel.removeSelected()

        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.products.count, 5)
    }

    func testPriceSortKeepsQuoteProductsAfterPricedItems() {
        let viewModel = FavoritesViewModel()

        viewModel.sortOption = .priceAscending
        XCTAssertFalse(viewModel.sortedProducts.first?.isPriceHidden ?? true)
        XCTAssertTrue(viewModel.sortedProducts.last?.isPriceHidden ?? false)
    }
}
