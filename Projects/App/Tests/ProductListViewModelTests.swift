import XCTest
@testable import EumShoppingMall

@MainActor
final class ProductListViewModelTests: XCTestCase {
    func testFilterCombinesBrandPriceShippingAndStockConditions() {
        let products = [
            product(id: "match", amount: 80_000, brand: "브랜드 A", shipping: .fast, soldOut: false),
            product(id: "price", amount: 150_000, brand: "브랜드 A", shipping: .fast, soldOut: false),
            product(id: "brand", amount: 80_000, brand: "브랜드 B", shipping: .fast, soldOut: false),
            product(id: "shipping", amount: 80_000, brand: "브랜드 A", shipping: .free, soldOut: false),
            product(id: "sold-out", amount: 80_000, brand: "브랜드 A", shipping: .fast, soldOut: true)
        ]
        let viewModel = ProductListViewModel(products: products)

        viewModel.applyFilter(ProductListFilter(
            priceRange: .under100Thousand,
            brand: "브랜드 A",
            shippingType: .fast,
            stock: .inStock
        ))

        XCTAssertEqual(viewModel.sortedProducts.map(\.id), ["match"])
    }

    func testResetFilterRestoresAllProductsAndBrandsIncludeOnlyMockValues() {
        let viewModel = ProductListViewModel(products: [
            product(id: "one", amount: 20_000, brand: "브랜드 B", shipping: .standard, soldOut: false),
            product(id: "two", amount: 800_000, brand: "브랜드 A", shipping: .free, soldOut: true)
        ])
        viewModel.applyFilter(ProductListFilter(stock: .inStock))

        viewModel.applyFilter(ProductListFilter())

        XCTAssertEqual(viewModel.sortedProducts.count, 2)
        XCTAssertEqual(viewModel.availableBrands, ["전체", "브랜드 A", "브랜드 B"])
    }

    func testFilterCanProduceAnEmptyProductResult() {
        let viewModel = ProductListViewModel(products: [
            product(id: "one", amount: 20_000, brand: "브랜드 A", shipping: .standard, soldOut: false)
        ])

        viewModel.applyFilter(ProductListFilter(brand: "브랜드 B"))

        XCTAssertTrue(viewModel.sortedProducts.isEmpty)
    }

    private func product(
        id: String,
        amount: Int,
        brand: String,
        shipping: ProductShippingType,
        soldOut: Bool
    ) -> HomeProduct {
        HomeProduct(
            id: id,
            title: id,
            price: "₩\(amount)",
            imageName: nil,
            isFavorite: false,
            isSoldOut: soldOut,
            isPriceHidden: false,
            priceAmount: amount,
            brand: brand,
            shippingType: shipping
        )
    }
}
