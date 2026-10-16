import Foundation
import Combine

struct HomeCategory: Identifiable {
    let id: String
    let title: String
    let iconName: String
}

struct HomeProduct: Identifiable {
    let id: String
    let title: String
    let price: String?
    let imageName: String?
    var isFavorite: Bool
    let isSoldOut: Bool
    let isPriceHidden: Bool
}

struct HomeHeroContent {
    let eyebrow: String
    let title: String
    let subtitle: String
    let imageName: String
    let actionTitle: String
}

struct HomeContent {
    let categories: [HomeCategory]
    let hero: HomeHeroContent
    var recommendedProducts: [HomeProduct]
    var bestSellerProducts: [HomeProduct]
    let cartCount: Int
}

struct HomeProductListSelection {
    let title: String
    let products: [HomeProduct]
}

extension CartItem {
    var homeProduct: HomeProduct {
        HomeProduct(
            id: id,
            title: title,
            price: isQuoteProduct ? nil : "₩00,000",
            imageName: "ProductPlaceholder",
            isFavorite: false,
            isSoldOut: isSoldOut,
            isPriceHidden: isQuoteProduct
        )
    }
}

protocol HomeRepository {
    func fetchHome() async throws -> HomeContent
}

struct MockHomeRepository: HomeRepository {
    func fetchHome() async throws -> HomeContent {
        HomeContent(
            categories: [
                HomeCategory(id: "ppe", title: "개인보호장비", iconName: "CategoryHardHat"),
                HomeCategory(id: "uniform", title: "작업복/\n유니폼", iconName: "CategoryClothing"),
                HomeCategory(id: "road", title: "교통·\n도로 안전", iconName: "CategoryRoad"),
                HomeCategory(id: "fire", title: "소방·\n방재용품", iconName: "CategoryFire"),
                HomeCategory(id: "industry", title: "산업\n현장용품", iconName: "CategoryIndustry"),
                HomeCategory(id: "security", title: "보안·감시", iconName: "CategorySecurity"),
                HomeCategory(id: "life", title: "생활\n안전용품", iconName: "CategoryLife"),
                HomeCategory(id: "custom", title: "맞춤 제작/\n납품", iconName: "CategoryCustom"),
                HomeCategory(id: "all", title: "전체보기", iconName: "CategoryAll")
            ],
            hero: HomeHeroContent(
                eyebrow: "Safe Tomorrow",
                title: "작은 변화가\n큰 안전을 만듭니다.",
                subtitle: "현장을 위한 통합 안전 솔루션",
                imageName: "HeroBannerPlaceholder",
                actionTitle: "자세히 보기"
            ),
            recommendedProducts: (0..<4).map { index in
                HomeProduct(
                    id: "recommended-\(index)",
                    title: "제품명",
                    price: "₩00,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: index == 0
                )
            },
            bestSellerProducts: (0..<4).map { index in
                HomeProduct(
                    id: "best-\(index)",
                    title: "제품명",
                    price: "₩00,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: index == 3,
                    isPriceHidden: false
                )
            },
            cartCount: 3
        )
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    enum State {
        case loading
        case content(HomeContent)
        case failed
    }

    @Published private(set) var state: State = .loading

    private let repository: HomeRepository

    init(repository: HomeRepository = MockHomeRepository()) {
        self.repository = repository
    }

    func load() async {
        state = .loading
        do {
            state = .content(try await repository.fetchHome())
        } catch {
            state = .failed
        }
    }

    func retry() async {
        await load()
    }

    func toggleFavorite(productID: String) {
        guard case var .content(content) = state else { return }
        content.recommendedProducts = toggledFavorites(in: content.recommendedProducts, productID: productID)
        content.bestSellerProducts = toggledFavorites(in: content.bestSellerProducts, productID: productID)
        state = .content(content)
    }

    private func toggledFavorites(in products: [HomeProduct], productID: String) -> [HomeProduct] {
        products.map { product in
            guard product.id == productID else { return product }
            var updated = product
            updated.isFavorite.toggle()
            return updated
        }
    }
}
