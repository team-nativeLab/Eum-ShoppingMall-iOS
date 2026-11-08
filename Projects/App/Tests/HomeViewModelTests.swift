import XCTest
@testable import EumShoppingMall

@MainActor
final class HomeViewModelTests: XCTestCase {
    func testMockHomeContentMatchesCurrentFigmaFeaturedProducts() async {
        let viewModel = HomeViewModel()
        await viewModel.load()

        guard case let .content(content) = viewModel.state else {
            XCTFail("홈 데이터가 표시 상태여야 합니다.")
            return
        }

        XCTAssertEqual(content.hero.eyebrow, "Safe Tomorrow")
        XCTAssertEqual(content.hero.title, "사람이 있는 곳에,\n더 안전한 내일을.")
        XCTAssertEqual(content.hero.imageName, "HomeHeroSafety")
        XCTAssertEqual(content.recommendedProducts.map(\.title), [
            "세이프가드 ABS 안전모", "경량 안전화 4인치", "전신 안전벨트", "코팅 장갑 10켤레"
        ])
        XCTAssertEqual(content.recommendedProducts[0].rating, 4.7)
        XCTAssertEqual(content.recommendedProducts[0].reviewCount, 3)
        XCTAssertEqual(content.recommendedProducts[0].originalPrice, "₩22,000")
        XCTAssertEqual(content.recommendedProducts[0].discountPercentage, 18)
        XCTAssertTrue(content.bestSellerProducts[3].isSoldOut)
    }

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
