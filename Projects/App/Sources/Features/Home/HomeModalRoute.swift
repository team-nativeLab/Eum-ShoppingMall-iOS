import Foundation

enum HomeModalRoute {
    case authentication
    case settingsLogin
    case quoteInquiry(HomeProduct?)
    case quoteDetail(QuoteInquiryRecord)
    case accountCollection(AccountCollectionDestination)
    case orderHistory
    case orderDetail(OrderHistoryItem)
    case deliveryTracking(OrderHistoryItem)
    case returnRequest(OrderHistoryItem)
    case returnHistory
    case accountVerification
    case settings
    case terms
    case termsPrevious
    case privacyPolicy
    case usageGuide
    case addressEditor(ShippingAddress?)
    case accountWithdrawalNotice
    case accountWithdrawalBlocked
    case accountWithdrawalReason
    case accountWithdrawalComplete, companyIntroduction
    case customerCenter
    case announcements
    case announcementDetail(AnnouncementItem)
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
