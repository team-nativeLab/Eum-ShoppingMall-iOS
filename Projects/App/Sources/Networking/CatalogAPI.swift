import Foundation

struct CatalogAPI {
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func categories() async throws -> [APICatalogCategory] {
        try await client.sendData(APIRequest<[APICatalogCategory]>(path: "api/v1/categories"))
    }

    func products(_ query: APICatalogProductQuery = APICatalogProductQuery()) async throws -> APIPage<APIProductSummary> {
        try await client.sendData(
            APIRequest<APIPage<APIProductSummary>>(
                path: "api/v1/products",
                queryItems: query.queryItems
            )
        )
    }

    func facets(categoryID: Int64? = nil, query: String? = nil) async throws -> APICatalogFacets {
        var queryItems: [URLQueryItem] = []
        if let categoryID {
            queryItems.append(URLQueryItem(name: "categoryId", value: String(categoryID)))
        }
        if let query {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        return try await client.sendData(
            APIRequest<APICatalogFacets>(path: "api/v1/products/facets", queryItems: queryItems)
        )
    }

    func suggestions(query: String? = nil) async throws -> [APICatalogSuggestion] {
        let queryItems = query.map { [URLQueryItem(name: "query", value: $0)] } ?? []
        return try await client.sendData(
            APIRequest<[APICatalogSuggestion]>(path: "api/v1/products/suggestions", queryItems: queryItems)
        )
    }

    func product(id: Int64) async throws -> APIProductDetail {
        try await client.sendData(APIRequest<APIProductDetail>(path: "api/v1/products/\(id)"))
    }
}

struct APICatalogProductQuery {
    var categoryID: Int64?
    var query: String?
    var brands: [String] = []
    var minimumPrice: Int64?
    var maximumPrice: Int64?
    var certified: Bool?
    var certificationCodes: [String] = []
    var excludesSoldOut: Bool?
    var sort: String?
    var page: Int?
    var size: Int?

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if let categoryID {
            items.append(URLQueryItem(name: "categoryId", value: String(categoryID)))
        }
        if let query {
            items.append(URLQueryItem(name: "query", value: query))
        }
        items.append(contentsOf: brands.map { URLQueryItem(name: "brand", value: $0) })
        if let minimumPrice {
            items.append(URLQueryItem(name: "minPrice", value: String(minimumPrice)))
        }
        if let maximumPrice {
            items.append(URLQueryItem(name: "maxPrice", value: String(maximumPrice)))
        }
        if let certified {
            items.append(URLQueryItem(name: "certified", value: String(certified)))
        }
        items.append(contentsOf: certificationCodes.map { URLQueryItem(name: "certification", value: $0) })
        if let excludesSoldOut {
            items.append(URLQueryItem(name: "excludeSoldOut", value: String(excludesSoldOut)))
        }
        if let sort {
            items.append(URLQueryItem(name: "sort", value: sort))
        }
        if let page {
            items.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let size {
            items.append(URLQueryItem(name: "size", value: String(size)))
        }
        return items
    }
}

struct APICatalogCategory: Decodable {
    let id: Int64?
    let parentId: Int64?
    let name: String?
    let slug: String?
    let description: String?
    let iconKey: String?
}

struct APIProductSummary: Decodable {
    let id: Int64?
    let categoryId: Int64?
    let name: String?
    let brand: String?
    let imageUrl: String?
    let price: Int64?
    let listPrice: Int64?
    let priceVisible: Bool
    let certifications: [APICertification]?
    let status: String?
    let soldOut: Bool
    let optionRequired: Bool
    let defaultSkuId: Int64?
}

struct APIProductDetail: Decodable {
    let id: Int64?
    let categoryId: Int64?
    let name: String?
    let brand: String?
    let description: String?
    let imageUrl: String?
    let price: Int64?
    let listPrice: Int64?
    let priceVisible: Bool
    let certifications: [APICertification]?
    let status: String?
    let soldOut: Bool
    let skus: [APICatalogSKU]?
}

struct APICatalogSKU: Decodable {
    let id: Int64?
    let optionName: String?
    let price: Int64?
    let soldOut: Bool
}

struct APICertification: Decodable {
    let code: String?
    let label: String?
}

struct APICatalogSuggestion: Decodable {
    let productId: Int64?
    let name: String?
    let brand: String?
}

struct APICatalogFacets: Decodable {
    let totalCount: Int64
    let keywordTotalCount: Int64
    let categories: [APICatalogFacet<Int64>]?
    let brands: [APICatalogFacet<String>]?
    let certifications: [APICatalogFacet<String>]?
}

struct APICatalogFacet<Value: Decodable>: Decodable {
    let value: Value?
    let label: String?
    let count: Int64
}
