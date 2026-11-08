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
    var priceAmount: Int?
    var brand: String?
    var shippingType: ProductShippingType?
    var rating: Double?
    var reviewCount: Int?
    var originalPrice: String?
    var discountPercentage: Int?
}

enum ProductShippingType: String, CaseIterable, Identifiable {
    case standard = "일반 배송"
    case fast = "빠른 배송"
    case free = "무료 배송"

    var id: String { rawValue }
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
                title: "사람이 있는 곳에,\n더 안전한 내일을.",
                subtitle: "현장의 안전이, 모두의 일상을 지킵니다.",
                imageName: "HomeHeroSafety",
                actionTitle: "제품 둘러보기"
            ),
            recommendedProducts: recommendedProducts,
            bestSellerProducts: bestSellerProducts,
            cartCount: 3
        )
    }

    private var recommendedProducts: [HomeProduct] {
        [
                HomeProduct(
                    id: "recommended-helmet",
                    title: "세이프가드 ABS 안전모",
                    price: "₩18,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: false,
                    priceAmount: 18_000,
                    brand: "세이프가드",
                    shippingType: .standard,
                    rating: 4.7,
                    reviewCount: 3,
                    originalPrice: "₩22,000",
                    discountPercentage: 18
                ),
                HomeProduct(
                    id: "recommended-boots",
                    title: "경량 안전화 4인치",
                    price: "₩54,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: false,
                    priceAmount: 54_000,
                    brand: "브랜드 B",
                    shippingType: .fast,
                    rating: 4.7,
                    reviewCount: 6
                ),
                HomeProduct(
                    id: "recommended-harness",
                    title: "전신 안전벨트",
                    price: nil,
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: true,
                    priceAmount: nil,
                    brand: "브랜드 C",
                    shippingType: .standard,
                    rating: 0,
                    reviewCount: 0
                ),
                HomeProduct(
                    id: "recommended-gloves",
                    title: "코팅 장갑 10켤레",
                    price: nil,
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: true,
                    priceAmount: nil,
                    brand: "브랜드 A",
                    shippingType: .standard,
                    rating: 4.0,
                    reviewCount: 1
                )
        ]
    }

    private var bestSellerProducts: [HomeProduct] {
        [
                HomeProduct(
                    id: "best-helmet",
                    title: "세이프가드 ABS 안전모",
                    price: "₩18,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: false,
                    priceAmount: 18_000,
                    brand: "세이프가드",
                    shippingType: .standard,
                    rating: 4.7,
                    reviewCount: 3,
                    originalPrice: "₩22,000",
                    discountPercentage: 18
                ),
                HomeProduct(
                    id: "best-boots",
                    title: "경량 안전화 4인치",
                    price: "₩54,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: false,
                    priceAmount: 54_000,
                    brand: "브랜드 B",
                    shippingType: .fast,
                    rating: 4.7,
                    reviewCount: 6
                ),
                HomeProduct(
                    id: "best-extinguisher",
                    title: "분말 소화기 3.3kg",
                    price: "₩32,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: false,
                    isPriceHidden: false,
                    priceAmount: 32_000,
                    brand: "브랜드 A",
                    shippingType: .free,
                    rating: 5.0,
                    reviewCount: 1,
                    originalPrice: "₩35,000",
                    discountPercentage: 8
                ),
                HomeProduct(
                    id: "best-winter-gloves",
                    title: "방한 작업 장갑",
                    price: "₩12,000",
                    imageName: nil,
                    isFavorite: false,
                    isSoldOut: true,
                    isPriceHidden: false,
                    priceAmount: 12_000,
                    brand: "브랜드 B",
                    shippingType: .standard,
                    rating: 0,
                    reviewCount: 0
                )
        ]
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
