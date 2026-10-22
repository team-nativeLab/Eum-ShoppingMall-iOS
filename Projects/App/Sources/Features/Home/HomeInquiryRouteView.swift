import SwiftUI

struct HomeInquiryRouteView: View {
    let route: HomeModalRoute
    @ObservedObject var contactInquiryViewModel: ContactInquiryHistoryViewModel
    let onBack: () -> Void
    let onSearch: () -> Void
    let onRoute: (HomeModalRoute) -> Void
    let onViewInquiries: () -> Void

    @ViewBuilder
    var body: some View {
        switch route {
        case let .inquiryCompose(context):
            InquiryComposeView(context: context, onBack: onBack) { inquiry in
                contactInquiryViewModel.add(inquiry)
                onRoute(.inquiryComplete)
            }
        case .inquiryComplete:
            InquiryCompletionView(onBack: onBack, onViewInquiries: onViewInquiries)
        case let .productReviews(product):
            ProductReviewsView(onBack: onBack, onSearch: onSearch) {
                onRoute(.productReviewRegistration(product))
            }
        case let .productReviewRegistration(product):
            ProductReviewRegistrationView(product: product, onBack: onBack, onSearch: onSearch)
        default:
            HomeRouteRecoveryView(onBack: onBack)
        }
    }
}
