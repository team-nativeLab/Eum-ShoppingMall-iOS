import Combine
import Foundation

enum CheckoutPaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "신용카드"
    case bankTransfer = "계좌이체"
    case virtualAccount = "가상계좌"
    case simplePayA = "간편결제 A"
    case simplePayB = "간편결제 B"
    case mobilePayment = "휴대폰 결제"

    var id: String { rawValue }
}

enum CheckoutReceiptOption: String, CaseIterable, Identifiable {
    case cashReceipt = "현금영수증"
    case taxInvoice = "세금계산서"
    case none = "신청 안 함"

    var id: String { rawValue }
}

enum CashReceiptPurpose: String, CaseIterable, Identifiable {
    case incomeDeduction = "소득공제용"
    case expenseEvidence = "지출증빙용"

    var id: String { rawValue }
}

@MainActor
final class CheckoutPaymentViewModel: ObservableObject {
    @Published private(set) var selectedPaymentMethod: CheckoutPaymentMethod = .creditCard
    @Published private(set) var selectedReceiptOption: CheckoutReceiptOption
    @Published private(set) var isOrderAgreementAccepted = false
    @Published private(set) var isEnteringTaxInvoiceInfo = false
    @Published var businessRegistrationNumber = ""
    @Published var taxInvoiceCompanyName = ""
    @Published var taxInvoiceRepresentativeName = ""
    @Published var taxInvoiceEmail = ""
    @Published private(set) var cashReceiptPurpose = CashReceiptPurpose.incomeDeduction
    @Published var cashReceiptIdentifier = "010-0000-0000"

    let availableCouponCount = 0
    let availablePoints = 0

    init(
        initialReceiptOption: CheckoutReceiptOption = .cashReceipt,
        startsWithDirectTaxInvoiceInput: Bool = false
    ) {
        selectedReceiptOption = initialReceiptOption
        isEnteringTaxInvoiceInfo = startsWithDirectTaxInvoiceInput
    }

    var canPay: Bool {
        guard isOrderAgreementAccepted else { return false }
        switch selectedReceiptOption {
        case .cashReceipt:
            return isCashReceiptInfoValid
        case .taxInvoice:
            return !isEnteringTaxInvoiceInfo || isTaxInvoiceInfoValid
        case .none:
            return true
        }
    }

    var isCashReceiptInfoValid: Bool {
        let digitCount = cashReceiptIdentifier.filter(\.isNumber).count
        return cashReceiptPurpose == .incomeDeduction ? digitCount >= 10 : digitCount == 10
    }

    var isTaxInvoiceInfoValid: Bool {
        businessRegistrationNumber.count == 10
            && !taxInvoiceCompanyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !taxInvoiceRepresentativeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && taxInvoiceEmail.contains("@") && taxInvoiceEmail.contains(".")
    }

    func selectPaymentMethod(_ method: CheckoutPaymentMethod) {
        selectedPaymentMethod = method
    }

    func selectReceiptOption(_ option: CheckoutReceiptOption) {
        selectedReceiptOption = option
    }

    func selectCashReceiptPurpose(_ purpose: CashReceiptPurpose) {
        guard cashReceiptPurpose != purpose else { return }
        cashReceiptPurpose = purpose
        cashReceiptIdentifier = ""
    }

    func updateCashReceiptIdentifier(_ value: String) {
        let maxDigits = cashReceiptPurpose == .incomeDeduction ? 11 : 10
        let digits = String(value.filter(\.isNumber).prefix(maxDigits))
        cashReceiptIdentifier = cashReceiptPurpose == .incomeDeduction ? Self.formatPhoneNumber(digits) : digits
    }

    func startTaxInvoiceInfoEntry() {
        isEnteringTaxInvoiceInfo = true
    }

    func updateBusinessRegistrationNumber(_ value: String) {
        businessRegistrationNumber = String(value.filter(\.isNumber).prefix(10))
    }

    func toggleOrderAgreement() {
        isOrderAgreementAccepted.toggle()
    }

    private static func formatPhoneNumber(_ digits: String) -> String {
        guard digits.count > 3 else { return digits }
        let prefix = String(digits.prefix(3))
        let middle = String(digits.dropFirst(3).prefix(4))
        let suffix = String(digits.dropFirst(7))
        return [prefix, middle, suffix].filter { !$0.isEmpty }.joined(separator: "-")
    }
}
