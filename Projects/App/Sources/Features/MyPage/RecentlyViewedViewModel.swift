import Combine
import Foundation

struct RecentlyViewedGroup: Identifiable {
    let id: UUID
    let date: String
    var products: [HomeProduct]

    init(id: UUID = UUID(), date: String, products: [HomeProduct]) {
        self.id = id
        self.date = date
        self.products = products
    }
}

@MainActor
final class RecentlyViewedViewModel: ObservableObject {
    @Published private(set) var groups: [RecentlyViewedGroup]

    init() {
        groups = Self.samples
    }

    init(groups: [RecentlyViewedGroup]) {
        self.groups = groups
    }

    static let samples = [
        RecentlyViewedGroup(
            date: "0000.00.00",
            products: [
                product("recent-1"),
                product("recent-2", isPriceHidden: true),
                product("recent-3"),
                product("recent-4")
            ]
        ),
        RecentlyViewedGroup(
            date: "0000.00.00",
            products: [
                product("recent-5", isSoldOut: true),
                product("recent-6")
            ]
        )
    ]

    var productCount: Int { groups.reduce(0) { $0 + $1.products.count } }

    func remove(productID: String) {
        groups = groups.compactMap { group in
            let products = group.products.filter { $0.id != productID }
            guard !products.isEmpty else { return nil }
            return RecentlyViewedGroup(id: group.id, date: group.date, products: products)
        }
    }

    func removeAll() {
        groups.removeAll()
    }

    private static func product(_ id: String, isSoldOut: Bool = false, isPriceHidden: Bool = false) -> HomeProduct {
        HomeProduct(
            id: id,
            title: "제품명",
            price: isPriceHidden ? nil : "₩00,000",
            imageName: nil,
            isFavorite: false,
            isSoldOut: isSoldOut,
            isPriceHidden: isPriceHidden
        )
    }
}
