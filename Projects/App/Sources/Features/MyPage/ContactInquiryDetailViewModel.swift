import Combine
import Foundation

@MainActor
final class ContactInquiryDetailViewModel: ObservableObject {
    let inquiry: ContactInquiryRecord

    init(inquiry: ContactInquiryRecord) {
        self.inquiry = inquiry
    }
}
