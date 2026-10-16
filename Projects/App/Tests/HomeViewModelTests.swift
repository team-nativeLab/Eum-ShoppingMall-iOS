import XCTest
@testable import EumShoppingMall

@MainActor
final class HomeViewModelTests: XCTestCase {
    func testFavoriteToggleUsesSameTransformationForBothProductSections() async {
        let sharedProduct = makeProduct(id: "shared", isFavorite: false)
        let recommendedOnly = makeProduct(id: "recommended-only", isFavorite: false)
        let bestSellerOnly = makeProduct(id: "best-seller-only", isFavorite: true)
        let content = HomeContent(
            categories: [],
            hero: HomeHeroContent(
                eyebrow: "",
                title: "",
                subtitle: "",
                imageName: "",
                actionTitle: ""
            ),
            recommendedProducts: [sharedProduct, recommendedOnly],
            bestSellerProducts: [sharedProduct, bestSellerOnly],
            cartCount: 0
        )
        let viewModel = HomeViewModel(repository: StubHomeRepository(content: content))

        await viewModel.load()
        viewModel.toggleFavorite(productID: sharedProduct.id)

        guard case let .content(updatedContent) = viewModel.state else {
            XCTFail("홈 데이터가 표시 상태여야 합니다.")
            return
        }

        XCTAssertTrue(updatedContent.recommendedProducts[0].isFavorite)
        XCTAssertFalse(updatedContent.recommendedProducts[1].isFavorite)
        XCTAssertTrue(updatedContent.bestSellerProducts[0].isFavorite)
        XCTAssertTrue(updatedContent.bestSellerProducts[1].isFavorite)
    }

    private func makeProduct(id: String, isFavorite: Bool) -> HomeProduct {
        HomeProduct(
            id: id,
            title: id,
            price: nil,
            imageName: nil,
            isFavorite: isFavorite,
            isSoldOut: false,
            isPriceHidden: false
        )
    }
}

private struct StubHomeRepository: HomeRepository {
    let content: HomeContent

    func fetchHome() async throws -> HomeContent {
        content
    }
}
