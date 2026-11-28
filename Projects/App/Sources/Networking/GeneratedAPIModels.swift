import Foundation

// Generated from the backend OpenAPI spec (/v3/api-docs). Keep field names in sync with Swagger.

struct APISummary: Decodable {
    let id: Int64?
    let name: String?
    let englishName: String?
    let logoUrl: String?
    let tagline: String?
    let productCount: Int64?
    let logoSettings: APIBrandImageSettings?
    let accentColor: String?
}

struct APIBrandImageSettings: Decodable {
    let fit: String?
    let width: Int?
    let height: Int?
}

struct APIBrandDetail: Decodable {
    let id: Int64?
    let name: String?
    let englishName: String?
    let logoUrl: String?
    let tagline: String?
    let productCount: Int64?
    let coverImageUrl: String?
    let mainField: String?
    let originCountry: String?
    let certification: String?
    let story: APIStory?
    let logoSettings: APIBrandImageSettings?
    let accentColor: String?
    let coverSettings: APIBrandImageSettings?
}

struct APIStory: Decodable {
    let title: String?
    let body: String?
}

struct APIShopEventResponse: Decodable {
    let id: Int64?
    let title: String?
    let subtitle: String?
    let status: String?
    let startAt: String?
    let endAt: String?
    let eyebrow: String?
    let heroTitle: [String]?
    let heroDescription: String?
    let body: String?
    let sections: [APIShopEventSectionResponse]?
    let searchKeyword: String?
}

struct APIShopEventSectionResponse: Decodable {
    let heading: String?
    let body: String?
}

struct APILegalDocumentResponse: Decodable {
    let type: String?
    let version: String?
    let title: String?
    let effectiveAt: String?
    let body: String?
}

struct APIVersion: Decodable {
    let version: String?
    let title: String?
    let effectiveAt: String?
    let current: Bool?
}

struct APIMemberAddressResponse: Decodable {
    let id: Int64?
    let label: String?
    let recipient: String?
    let recipientPhone: String?
    let zipCode: String?
    let address: String?
    let addressDetail: String?
    let isDefault: Bool?
}

struct APIMemberAddressRequest: Encodable {
    let label: String
    let recipient: String
    let recipientPhone: String
    let zipCode: String
    let address: String
    let addressDetail: String?
    let isDefault: Bool?
}

struct APIProductReviewResponse: Decodable {
    let id: Int64?
    let authorName: String?
    let rating: Int?
    let content: String?
    let optionLabel: String?
    let createdAt: String?
    let adminReply: String?
    let adminRepliedAt: String?
    let isMine: Bool?
}

struct APIProductReviewCreateRequest: Encodable {
    let orderItemId: Int64
    let rating: Int
    let content: String
}

struct APIProductReviewSummaryResponse: Decodable {
    let productId: Int64?
    let averageRating: Double?
    let totalCount: Int64?
    let ratingCounts: [String: String]?
    let photoReviewCount: Int64?
}

struct APIReviewableItemResponse: Decodable {
    let orderItemId: Int64?
    let orderNo: String?
    let orderedAt: String?
    let productId: Int64?
    let productName: String?
    let optionLabel: String?
    let imageUrl: String?
}

struct APIProductQuestionResponse: Decodable {
    let id: Int64?
    let authorName: String?
    let title: String?
    let content: String?
    let isPrivate: Bool?
    let status: String?
    let createdAt: String?
    let answer: String?
    let answeredAt: String?
    let isMine: Bool?
}

struct APIProductQuestionCreateRequest: Encodable {
    let title: String
    let content: String
    let isPrivate: Bool?
}

struct APIPopupResponse: Decodable {
    let id: Int64?
    let title: String?
    let imageUrl: String?
    let body: String?
}

struct APICompanyInfo: Decodable {
    let companyName: String
    let representative: String
    let businessRegistrationNumber: String
    let mailOrderSalesNumber: String?
    let address: String
    let email: String
    let quoteEmail: String?
    let privacyOfficer: String?
    let customerCenterPhone: String
    let customerCenterTel: String?
    let customerCenterHours: String
}

struct APICheckoutOptionsResponse: Decodable {
    let shippingFee: Int64?
    let freeShippingThreshold: Int64?
    let freeShippingScope: String?
    let baseFeeMode: String?
    let deliveryRequests: [APIOption]?
    let shippingMethods: [APIShippingMethod]?
    let paymentMethods: [APIOption]?
}

struct APIOption: Decodable {
    let id: String?
    let label: String?
}

struct APIShippingMethod: Decodable {
    let id: String?
    let label: String?
    let description: String?
}

struct APISocialAccountResponse: Decodable {
    let provider: String?
    let email: String?
    let linkedAt: String?
}

struct APIMarketingConsentResponse: Decodable {
    let agreed: Bool?
    let changedAt: String?
}

struct APIMarketingConsentRequest: Encodable {
    let agreed: Bool
}
