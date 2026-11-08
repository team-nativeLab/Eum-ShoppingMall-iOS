import Combine
import Foundation

enum FavoritesSortOption: String, CaseIterable, Identifiable {
    case recent = "최근 찜한 순"
    case priceAscending = "낮은 가격순"
    case priceDescending = "높은 가격순"

    var id: String { rawValue }
}

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var products: [HomeProduct]
    @Published var sortOption: FavoritesSortOption = .recent
    @Published var isEditing = false
    @Published private(set) var selectedProductIDs: Set<String> = []

    init() {
        products = Self.samples
    }

    init(products: [HomeProduct]) {
        self.products = products
    }

    static let samples = [
        HomeProduct(
            id: "favorite-1", title: "제품명", price: "₩00,000", imageName: nil,
            isFavorite: true, isSoldOut: false, isPriceHidden: false
        ),
        HomeProduct(
            id: "favorite-2", title: "제품명", price: "₩00,000", imageName: nil,
            isFavorite: true, isSoldOut: false, isPriceHidden: false
        ),
        HomeProduct(
            id: "favorite-3", title: "제품명", price: nil, imageName: nil,
            isFavorite: true, isSoldOut: false, isPriceHidden: true
        ),
        HomeProduct(
            id: "favorite-4", title: "제품명", price: "₩00,000", imageName: nil,
            isFavorite: true, isSoldOut: true, isPriceHidden: false
        ),
        HomeProduct(
            id: "favorite-5", title: "제품명", price: "₩00,000", imageName: nil,
            isFavorite: true, isSoldOut: false, isPriceHidden: false
        ),
        HomeProduct(
            id: "favorite-6", title: "제품명", price: nil, imageName: nil,
            isFavorite: true, isSoldOut: true, isPriceHidden: true
        )
    ]

    var sortedProducts: [HomeProduct] {
        switch sortOption {
        case .recent:
            products
        case .priceAscending:
            products.sorted { priceValue($0) < priceValue($1) }
        case .priceDescending:
            products.sorted { priceValue($0) > priceValue($1) }
        }
    }

    var selectedCount: Int { selectedProductIDs.count }

    func toggleEditing() {
        isEditing.toggle()
        selectedProductIDs.removeAll()
    }

    func toggleSelection(productID: String) {
        if selectedProductIDs.contains(productID) {
            selectedProductIDs.remove(productID)
        } else {
            selectedProductIDs.insert(productID)
        }
    }

    func removeFavorite(productID: String) {
        products.removeAll { $0.id == productID }
        selectedProductIDs.remove(productID)
    }

    func removeSelected() {
        products.removeAll { selectedProductIDs.contains($0.id) }
        selectedProductIDs.removeAll()
        isEditing = false
    }

    private func priceValue(_ product: HomeProduct) -> Int {
        guard !product.isPriceHidden, let price = product.price else { return Int.max }
        return Int(price.filter(\.isNumber)) ?? Int.max
    }
}
