import Combine
import Foundation

enum ContactInquiryStatus: String, CaseIterable, Identifiable {
    case all = "전체"
    case pending = "답변대기"
    case answered = "답변완료"

    var id: String { rawValue }
}

struct ContactInquiryRecord: Identifiable, Equatable {
    let id: String
    let date: String
    let category: String
    let status: ContactInquiryStatus
    let title: String
    let summary: String
}

@MainActor
final class ContactInquiryHistoryViewModel: ObservableObject {
    @Published var selectedStatus: ContactInquiryStatus = .all

    let inquiries = [
        record("contact-1", status: .pending),
        record("contact-2", status: .answered),
        record("contact-3", status: .pending),
        record("contact-4", status: .answered)
    ]

    var visibleInquiries: [ContactInquiryRecord] {
        guard selectedStatus != .all else { return inquiries }
        return inquiries.filter { $0.status == selectedStatus }
    }

    private static func record(_ id: String, status: ContactInquiryStatus) -> ContactInquiryRecord {
        ContactInquiryRecord(
            id: id,
            date: "0000.00.00",
            category: "문의 유형",
            status: status,
            title: "문의 제목",
            summary: "문의 내용"
        )
    }
}
