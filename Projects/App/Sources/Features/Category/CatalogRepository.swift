import Foundation

/// Loads categories and category products from the server (`/api/v1/categories`, `/api/v1/products`).
/// UI tests and Figma capture runs keep the local samples so they do not depend on live server data.
@MainActor
struct CatalogRepository {
    static var usesLocalSamples: Bool {
        #if DEBUG
        let process = ProcessInfo.processInfo
        // Xcode previews must stay self-contained and never hit the live server.
        if process.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        return process.arguments.contains("-ui-test-local-data") || process.arguments.contains("-debug-screen")
        #else
        false
        #endif
    }

    /// Server categories have no icons yet (`iconKey` is null), so known slugs map to existing assets.
    static func iconName(slug: String?, iconKey: String?) -> String {
        if let iconKey, !iconKey.isEmpty { return iconKey }
        switch slug {
        case "head-protection": return "CategoryHardHat"
        default: return "CategoryAll"
        }
    }

    private let catalog: CatalogAPI?

    init(catalog: CatalogAPI? = AppServices.shared.api?.catalog) {
        self.catalog = catalog
    }

    func categories() async throws -> [HomeCategory] {
        guard let catalog else { throw APIClientError.missingBaseURL }
        return try await catalog.categories()
            .filter { $0.parentId == nil }
            .compactMap { category in
                guard let id = category.id, let name = category.name else { return nil }
                return HomeCategory(
                    id: String(id),
                    title: name,
                    iconName: Self.iconName(slug: category.slug, iconKey: category.iconKey)
                )
            }
    }

    func products(categoryID: String) async throws -> [HomeProduct] {
        guard let catalog else { throw APIClientError.missingBaseURL }
        var query = APICatalogProductQuery()
        query.categoryID = Int64(categoryID)
        return try await catalog.products(query).content.map(HomeProduct.init(summary:))
    }
}

extension HomeProduct {
    /// Maps a server product summary to the card model used by lists.
    init(summary: APIProductSummary) {
        let priceVisible = summary.priceVisible
        self.init(
            id: summary.id.map(String.init) ?? UUID().uuidString,
            title: summary.name ?? "",
            price: priceVisible ? summary.price.map(Self.wonText) : nil,
            imageName: "ProductPlaceholder",
            isFavorite: false,
            isSoldOut: summary.soldOut,
            isPriceHidden: !priceVisible
        )
        priceAmount = summary.price.map { Int($0) }
        brand = summary.brand
        rating = summary.rating
        reviewCount = summary.reviewCount
        if priceVisible, let list = summary.listPrice, let price = summary.price, list > price, list > 0 {
            originalPrice = Self.wonText(list)
            discountPercentage = Int((Double(list - price) / Double(list) * 100).rounded())
        }
    }

    static func wonText(_ amount: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "₩" + (formatter.string(from: NSNumber(value: amount)) ?? String(amount))
    }
}
