import XCTest
@testable import EumShoppingMall

@MainActor
final class BrandDetailViewModelTests: XCTestCase {
    func testBrandDetailUsesMockProductsAndFiltersByCategory() {
        let viewModel = BrandDetailViewModel(brandID: "brand-a")

        XCTAssertEqual(viewModel.brandName, "브랜드 A")
        XCTAssertEqual(viewModel.filteredProducts.count, 6)

        viewModel.selectedCategory = "작업복/유니폼"
        XCTAssertEqual(viewModel.filteredProducts.count, 2)
    }

    func testStoryAndFavoriteStatesCanBeChanged() {
        let viewModel = BrandDetailViewModel(brandID: "brand-a")
        let product = viewModel.products[0].product

        XCTAssertFalse(viewModel.isStoryExpanded)
        viewModel.toggleStoryExpansion()
        XCTAssertTrue(viewModel.isStoryExpanded)

        XCTAssertFalse(viewModel.isFavorite(product))
        viewModel.toggleFavorite(productID: product.id)
        XCTAssertTrue(viewModel.isFavorite(product))
    }
}
