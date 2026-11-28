#if DEBUG
import Foundation

/// Debug-only launch routing used to capture screens for Figma comparison.
/// Usage: `xcrun simctl launch booted <bundle id> -debug-screen A-22`
enum DebugScreenAction {
    case tab(EUMTabBar.Tab)
    case guestTab(EUMTabBar.Tab)
    case route(HomeModalRoute)
    case destination(HomeDestination)
    case drawer
}

enum DebugScreenLaunch {
    static let argument = "-debug-screen"

    static func requestedCode(arguments: [String] = ProcessInfo.processInfo.arguments) -> String? {
        guard let index = arguments.firstIndex(of: argument), arguments.indices.contains(index + 1) else {
            return nil
        }
        return arguments[index + 1]
    }

    /// Figma screen codes this launcher can open. Duplicate Figma numbers carry a suffix.
    static let supportedCodes = [
        "A-02", "A-03", "A-04", "A-05", "A-05h", "A-06", "A-07", "A-08", "A-09", "A-10", "A-10v",
        "A-11", "A-11g", "A-12", "A-13", "A-15", "A-16", "A-17", "A-18", "A-19", "A-19c", "A-19l", "A-19s",
        "A-20", "A-21", "A-22", "A-22p", "A-23", "A-23e", "A-24", "A-24e", "A-25", "A-25d",
        "A-26", "A-26b", "A-26r", "A-26d", "A-31", "A-32", "A-35", "A-36", "A-37", "A-38",
        "A-42", "A-40", "A-41", "A-43-company", "A-45", "A-54-events", "A-55", "A-57",
        "A-31d", "A-43-inquiry", "A-44", "A-50", "A-51", "A-51-withdrawn", "A-52", "A-53", "A-54-reject",
        "reviews", "review-write",
        "A-14", "A-27", "A-27r", "A-27z", "A-28", "A-28n", "A-28d",
        "A-09c", "A-09c-p", "A-09t", "A-09t-in"
    ]

    /// Receipt states for A-09c, A-09c-p, A-09t and A-09t-in (Figma shows bank transfer selected).
    @MainActor
    static func checkoutPaymentViewModel() -> CheckoutPaymentViewModel? {
        switch requestedCode() {
        case "A-09c": CheckoutPaymentViewModel(initialReceiptOption: .cashReceipt, initialPaymentMethod: .bankTransfer)
        case "A-09c-p":
            CheckoutPaymentViewModel(
                initialReceiptOption: .cashReceipt, initialPaymentMethod: .bankTransfer, initialCashReceiptPurpose: .expenseEvidence
            )
        case "A-09t": CheckoutPaymentViewModel(initialReceiptOption: .taxInvoice, initialPaymentMethod: .bankTransfer)
        case "A-09t-in":
            CheckoutPaymentViewModel(
                initialReceiptOption: .taxInvoice, startsWithDirectTaxInvoiceInput: true, initialPaymentMethod: .bankTransfer
            )
        default: nil
        }
    }

    static func perform(
        _ actions: [DebugScreenAction],
        tab: (_ tab: EUMTabBar.Tab, _ asGuest: Bool) -> Void,
        route: (HomeModalRoute) -> Void,
        destination: (HomeDestination) -> Void,
        drawer: () -> Void
    ) {
        for action in actions {
            switch action {
            case let .tab(selected): tab(selected, false)
            case let .guestTab(selected): tab(selected, true)
            case let .route(selected): route(selected)
            case let .destination(selected): destination(selected)
            case .drawer: drawer()
            }
        }
    }

    @MainActor
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func actions(for code: String, content: HomeContent) -> [DebugScreenAction]? {
        let products = content.recommendedProducts + content.bestSellerProducts
        let pricedProduct = products.first { $0.price != nil } ?? products.first
        let hiddenPriceProduct = products.first { $0.price == nil }
        let order = OrderHistoryItem.samples.first { $0.status == .inTransit } ?? OrderHistoryItem.samples.first
        let deliveredOrder = OrderHistoryItem.samples.first { $0.status == .delivered } ?? order
        let requestedReturn = ReturnHistoryItem.samples.first { $0.status == .requested } ?? ReturnHistoryItem.samples.first
        let withdrawnReturn = ReturnHistoryItem.samples.first { $0.status == .withdrawn }
        let rejectedReturn = ReturnHistoryItem.samples.first { $0.status == .rejected }

        switch code {
        case "A-02": return [.tab(.home)]
        case "A-03": return [.tab(.category)]
        case "A-04": return [.destination(.productList(HomeProductListSelection(title: "전체 제품", products: products)))]
        case "A-05": return pricedProduct.map { [.destination(.product($0))] }
        case "A-05h": return hiddenPriceProduct.map { [.destination(.product($0))] }
        case "A-06": return [.tab(.search)]
        case "A-07": return [.tab(.cart)]
        case "A-08": return [.destination(.checkoutAddress)]
        case "A-09", "A-09c", "A-09c-p", "A-09t", "A-09t-in": return [.destination(.checkoutPayment)]
        case "A-10": return [.destination(.checkoutComplete(.creditCard))]
        case "A-10v": return [.destination(.checkoutComplete(.virtualAccount))]
        case "A-11": return [.tab(.account)]
        case "A-11g": return [.guestTab(.account)]
        case "A-12": return [.drawer]
        case "A-13", "A-14", "A-27", "A-27r", "A-27z", "A-28", "A-28n", "A-28d": return [.route(.authentication)]
        case "A-15": return [.route(.quoteInquiry(nil))]
        case "A-16": return [.route(.orderHistory())]
        case "A-17": return order.map { [.route(.orderDetail($0))] }
        case "A-18": return order.map { [.route(.deliveryTracking($0))] }
        case "A-19": return deliveredOrder.map { [.route(.returnRequest($0))] }
        case "A-19c": return [.route(.returnHub)]
        case "A-19l": return [.route(.returnHistory)]
        case "A-19s": return [.route(.returnOrderSelection)]
        case "A-20": return [.route(.accountCollection(.favorites))]
        case "A-21": return [.route(.accountCollection(.recentlyViewed))]
        case "A-22": return [.route(.accountCollection(.coupons))]
        case "A-22p": return [.route(.accountCollection(.points))]
        case "A-23": return [.route(.accountVerification)]
        case "A-23e": return [.route(.accountCollection(.editProfile))]
        case "A-24": return [.route(.accountCollection(.addresses))]
        case "A-24e": return [.route(.addressEditor(nil))]
        case "A-25": return [.route(.accountCollection(.quoteHistory))]
        case "A-25d": return QuoteHistoryViewModel.samples.first.map { [.route(.quoteDetail($0))] }
        case "A-26": return [.route(.accountWithdrawalNotice)]
        case "A-26b": return [.route(.accountWithdrawalBlocked)]
        case "A-26r": return [.route(.accountWithdrawalReason)]
        case "A-26d": return [.route(.accountWithdrawalComplete)]
        case "A-31": return [.route(.accountCollection(.contactHistory))]
        case "A-32": return [.route(.accountCollection(.notifications))]
        case "A-35": return [.route(.settings)]
        case "A-36": return [.route(.terms)]
        case "A-37": return [.route(.privacyPolicy)]
        case "A-38": return [.route(.usageGuide)]
        case "A-40": return [.route(.announcements)]
        case "A-41": return AnnouncementsViewModel.mockAnnouncements.first { $0.opensDetail }.map { [.route(.announcementDetail($0))] }
        case "A-42": return [.route(.customerCenter)]
        case "A-43-company": return [.route(.companyIntroduction)]
        case "A-45": return [.route(.inquiryComplete)]
        case "A-54-events": return [.route(.events)]
        case "A-55": return EventItem.samples.first.map { [.route(.eventDetail($0))] }
        case "A-57": return [.route(.openSourceLicenses)]
        case "A-31d": return ContactInquiryHistoryViewModel().inquiries.first.map { [.route(.accountCollection(.contactDetail($0)))] }
        case "A-43-inquiry": return [.route(.inquiryCompose(.contact))]
        case "A-44": return pricedProduct.map { [.route(.inquiryCompose(.product(name: $0.title)))] }
        case "A-50": return requestedReturn.map { [.route(.returnRequestComplete($0))] }
        case "A-51": return requestedReturn.map { [.route(.returnRequestDetail($0))] }
        case "A-51-withdrawn": return withdrawnReturn.map { [.route(.returnRequestDetail($0))] }
        case "A-52": return requestedReturn.map { [.route(.returnWithdrawalConfirmation($0))] }
        case "A-53": return requestedReturn.map { [.route(.returnWithdrawalComplete($0))] }
        case "A-54-reject": return rejectedReturn.map { [.route(.returnRejectionReason($0))] }
        case "reviews": return pricedProduct.map { [.route(.productReviews($0))] }
        case "review-write": return pricedProduct.map { [.route(.productReviewRegistration($0))] }
        default: return nil
        }
    }
}
#endif
