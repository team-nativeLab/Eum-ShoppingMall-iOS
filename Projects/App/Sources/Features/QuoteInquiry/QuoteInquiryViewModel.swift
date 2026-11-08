import Foundation
import Combine

struct QuoteInquiryProduct: Identifiable, Equatable {
    let id: String
    let name: String
    let option: String
    let quantity: Int

    static let sample = QuoteInquiryProduct(
        id: "quote-product-sample",
        name: "제품명",
        option: "L",
        quantity: 300
    )
}

struct QuoteInquiryCompletionDetails {
    let inquiryNumber: String
    let inquiryType: String
    let companyName: String
    let contactName: String
    let productSummary: String
    let deliveryDate: String
}

enum QuoteInquiryType: String, CaseIterable, Identifiable {
    case custom = "맞춤 제작"
    case bulk = "대량 구매"
    case regularSupply = "정기 납품"
    case other = "기타"

    var id: String { rawValue }
}

@MainActor
final class QuoteInquiryViewModel: ObservableObject {
    @Published private(set) var products: [QuoteInquiryProduct]
    @Published var inquiryType = QuoteInquiryType.custom
    @Published var company = "회사명"
    @Published var contactName = "홍길동"
    @Published var phoneNumber = "010-0000-0000"
    @Published var email = "example@email.com"
    @Published var deliveryDate = ""
    @Published var deliveryArea = ""
    @Published var details = ""
    @Published private(set) var attachmentNames: [String] = []
    @Published private(set) var agreedToPrivacy = false

    init(product: HomeProduct? = nil) {
        if let product {
            products = [QuoteInquiryProduct(
                id: product.id,
                name: product.title,
                option: "L",
                quantity: 300
            )]
        } else {
            products = [.sample]
        }
    }

    var canSubmit: Bool {
        !products.isEmpty && !company.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !contactName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && phoneNumber.filter(\.isNumber).count >= 10
            && email.contains("@") && email.contains(".") && agreedToPrivacy
            && details.count <= 1_000
    }

    var completionDetails: QuoteInquiryCompletionDetails {
        let productSummary = products.first.map { product in
            "\(product.name) 외 \(max(products.count - 1, 0))건"
        } ?? "제품 없음"
        return QuoteInquiryCompletionDetails(
            inquiryNumber: "Q-00000000-000",
            inquiryType: inquiryType.rawValue,
            companyName: company,
            contactName: contactName,
            productSummary: productSummary,
            deliveryDate: deliveryDate.isEmpty ? "0000.00.00" : deliveryDate
        )
    }

    func addSampleProduct() {
        let product = QuoteInquiryProduct(
            id: "quote-product-\(products.count + 1)",
            name: "제품명",
            option: "L",
            quantity: 300
        )
        products.append(product)
    }

    func removeProduct(id: String) {
        products.removeAll { $0.id == id }
    }

    func addAttachments(_ names: [String]) {
        attachmentNames.append(contentsOf: names)
    }

    func togglePrivacyAgreement() {
        agreedToPrivacy.toggle()
    }
}
