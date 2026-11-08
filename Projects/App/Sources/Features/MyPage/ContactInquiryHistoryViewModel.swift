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
    let relatedOrderNumber: String
    let content: String
    let attachmentName: String?
    let answerDate: String?
    let answer: String?
    var isPrivate = false
}

@MainActor
final class ContactInquiryHistoryViewModel: ObservableObject {
    @Published var selectedStatus: ContactInquiryStatus = .all

    @Published private(set) var inquiries: [ContactInquiryRecord]

    init(inquiries: [ContactInquiryRecord]? = nil) {
        self.inquiries = inquiries ?? Self.sampleInquiries
    }

    var visibleInquiries: [ContactInquiryRecord] {
        guard selectedStatus != .all else { return inquiries }
        return inquiries.filter { $0.status == selectedStatus }
    }

    func add(_ inquiry: ContactInquiryRecord) {
        inquiries.insert(inquiry, at: 0)
        selectedStatus = .all
    }

    private static let sampleInquiries = [
        record("contact-1", status: .pending),
        record("contact-2", status: .answered),
        record("contact-3", status: .pending),
        record("contact-4", status: .answered)
    ]

    private static func record(_ id: String, status: ContactInquiryStatus) -> ContactInquiryRecord {
        ContactInquiryRecord(
            id: id,
            date: "0000.00.00",
            category: "문의 유형",
            status: status,
            title: "문의 제목",
            summary: "문의 내용",
            relatedOrderNumber: "0000000000",
            content: "문의 내용",
            attachmentName: "첨부파일.jpg",
            answerDate: status == .answered ? "0000.00.00 00:00" : nil,
            answer: status == .answered ? "답변 내용" : nil
        )
    }
}
