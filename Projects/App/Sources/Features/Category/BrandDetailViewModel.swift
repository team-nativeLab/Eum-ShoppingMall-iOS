import Combine
import Foundation

struct BrandDetailProduct: Identifiable {
    let product: HomeProduct
    let category: String

    var id: String { product.id }
}

@MainActor
final class BrandDetailViewModel: ObservableObject {
    enum SortOption: String, CaseIterable, Identifiable {
        case recommended = "추천순"
        case priceAscending = "낮은 가격순"
        case priceDescending = "높은 가격순"

        var id: String { rawValue }
    }

    @Published private(set) var isStoryExpanded = false
    @Published var selectedCategory = "전체"
    @Published var sortOption = SortOption.recommended
    @Published private(set) var favoriteIDs: Set<String> = []

    let brandID: String
    let brandName: String
    let categories = ["전체", "개인보호장비", "작업복/유니폼", "교통·도로 안전"]
    private static let productCategorySamples = [
        "개인보호장비",
        "개인보호장비",
        "작업복/유니폼",
        "교통·도로 안전",
        "개인보호장비",
        "작업복/유니폼"
    ]
    let products: [BrandDetailProduct]
    let otherBrands = ["브랜드 B", "브랜드 C", "브랜드 D"]
    let otherBrandIDs = ["brand-b", "brand-c", "brand-d"]
    let story = "브랜드 소개 본문이 들어갑니다. 서버에서 받은 브랜드 스토리를 표시하며, 모바일에서는 여섯 줄까지 보여 준 뒤 더 보기로 펼칩니다. " +
        "브랜드의 시작, 주력 분야, 현장에서의 쓰임, 인증과 품질 관리, 납품 이력처럼 구매 담당자가 신뢰를 확인할 수 있는 내용을 담습니다."

    init(brandID: String) {
        self.brandID = brandID
        let suffix = brandID.last.map { String($0).uppercased() } ?? "A"
        brandName = "브랜드 \(suffix)"
        products = (0..<6).map { index in
            let product = HomeProduct(
                id: "\(brandID)-product-\(index)",
                title: "제품명",
                price: "₩00,000",
                imageName: nil,
                isFavorite: false,
                isSoldOut: index == 4,
                isPriceHidden: index == 2
            )
            return BrandDetailProduct(product: product, category: Self.productCategorySamples[index])
        }
    }

    var filteredProducts: [BrandDetailProduct] {
        let categoryFiltered = products.filter { selectedCategory == "전체" || $0.category == selectedCategory }
        switch sortOption {
        case .recommended:
            return categoryFiltered
        case .priceAscending:
            return categoryFiltered.sorted {
                ($0.product.price ?? "").localizedStandardCompare($1.product.price ?? "") == .orderedAscending
            }
        case .priceDescending:
            return categoryFiltered.sorted {
                ($0.product.price ?? "").localizedStandardCompare($1.product.price ?? "") == .orderedDescending
            }
        }
    }

    func toggleStoryExpansion() {
        isStoryExpanded.toggle()
    }

    func toggleFavorite(productID: String) {
        if favoriteIDs.contains(productID) {
            favoriteIDs.remove(productID)
        } else {
            favoriteIDs.insert(productID)
        }
    }

    func isFavorite(_ product: HomeProduct) -> Bool {
        product.isFavorite || favoriteIDs.contains(product.id)
    }
}
