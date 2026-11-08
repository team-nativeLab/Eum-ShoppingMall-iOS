import Combine
import Foundation

enum QuoteInquiryStatus: String, CaseIterable, Identifiable {
    case all = "전체"
    case received = "접수"
    case consulting = "상담중"
    case quoteSent = "견적 발송"
    case completed = "완료"
    case canceled = "취소"

    var id: String { rawValue }
}

struct QuoteInquiryRecord: Identifiable, Equatable {
    let id: String
    let date: String
    let inquiryNumber: String
    let status: QuoteInquiryStatus
    let title: String
    let productSummary: String
    let showsDocument: Bool
}

@MainActor
final class QuoteHistoryViewModel: ObservableObject {
    @Published var selectedStatus: QuoteInquiryStatus = .all

    let inquiries: [QuoteInquiryRecord]

    static let samples = [
        record("quote-1", status: .quoteSent, showsDocument: true),
        record("quote-2", status: .consulting),
        record("quote-3", status: .received),
        record("quote-4", status: .completed),
        record("quote-5", status: .canceled)
    ]

    init(inquiries: [QuoteInquiryRecord]? = nil) {
        self.inquiries = inquiries ?? (AccountSampleData.isEmpty ? [] : Self.samples)
    }

    var visibleInquiries: [QuoteInquiryRecord] {
        guard selectedStatus != .all else { return inquiries }
        return inquiries.filter { $0.status == selectedStatus }
    }

    private static func record(
        _ id: String,
        status: QuoteInquiryStatus,
        showsDocument: Bool = false
    ) -> QuoteInquiryRecord {
        QuoteInquiryRecord(
            id: id,
            date: "0000.00.00",
            inquiryNumber: "0000000000",
            status: status,
            title: "견적 문의 제목",
            productSummary: "제품명 외 0건 · 총 0개",
            showsDocument: showsDocument
        )
    }
}
