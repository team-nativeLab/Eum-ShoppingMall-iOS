import Foundation

enum HomeModalRoute {
    case authentication
    case settingsLogin
    case quoteInquiry(HomeProduct?)
    case quoteDetail(QuoteInquiryRecord)
    case accountCollection(AccountCollectionDestination)
    case orderHistory(status: OrderHistoryStatus = .all)
    case orderDetail(OrderHistoryItem)
    case deliveryTracking(OrderHistoryItem)
    case returnRequest(OrderHistoryItem)
    case returnHub
    case returnOrderSelection
    case returnRejectionReason(ReturnHistoryItem)
    case returnHistory
    case returnRequestDetail(ReturnHistoryItem)
    case returnWithdrawalConfirmation(ReturnHistoryItem)
    case accountVerification
    case settings
    case terms
    case privacyPolicy
    case usageGuide
    case openSourceLicenses
    case addressEditor(ShippingAddress?)
    case accountWithdrawalNotice
    case accountWithdrawalBlocked
    case accountWithdrawalReason
    case accountWithdrawalComplete, companyIntroduction
    case customerCenter
    case announcements
    case announcementDetail(AnnouncementItem)
    case events
    case eventDetail(EventItem)
    case shippingPolicy(HomeProduct)
    case inquiryCompose(InquiryComposeContext)
    case inquiryComplete
    case productReviews(HomeProduct)
    case productReviewRegistration(HomeProduct)
}

enum AccountCollectionDestination {
    case favorites
    case recentlyViewed
    case coupons
    case points
    case editProfile
    case addresses
    case quoteHistory
    case contactHistory
    case contactDetail(ContactInquiryRecord)
    case notifications
}

extension HomeModalRoute {
    static func destination(for notificationKind: NotificationKind) -> HomeModalRoute {
        switch notificationKind {
        case .delivery: .orderHistory(status: .inTransit)
        case .order: .orderHistory()
        case .quote: .accountCollection(.quoteHistory)
        case .contact: .accountCollection(.contactHistory)
        case .notice: .announcements
        }
    }
}
