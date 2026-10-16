import Foundation

struct AnnouncementItem: Identifiable, Equatable {
    let id: String
    let title: String
    let date: String
    let isPinned: Bool
    let opensDetail: Bool
}

struct AnnouncementsViewModel {
    let announcements: [AnnouncementItem]

    init(announcements: [AnnouncementItem] = Self.mockAnnouncements) {
        self.announcements = announcements
    }

    var isEmpty: Bool {
        announcements.isEmpty
    }

    static let mockAnnouncements = [
        AnnouncementItem(id: "notice-1", title: "[공지] 개인정보 처리방침 개정 안내", date: "0000.00.00", isPinned: true, opensDetail: true),
        AnnouncementItem(id: "notice-2", title: "[공지] 설 연휴 배송 일정 안내", date: "0000.00.00", isPinned: true, opensDetail: false),
        AnnouncementItem(id: "notice-3", title: "공지사항 제목이 들어갑니다", date: "0000.00.00", isPinned: false, opensDetail: false),
        AnnouncementItem(
            id: "notice-4",
            title: "공지사항 제목이 들어갑니다. 제목이 길면 두 줄까지 보여 주고 나머지는 말줄임합니다",
            date: "0000.00.00",
            isPinned: false,
            opensDetail: false
        ),
        AnnouncementItem(id: "notice-5", title: "공지사항 제목이 들어갑니다", date: "0000.00.00", isPinned: false, opensDetail: false),
        AnnouncementItem(id: "notice-6", title: "공지사항 제목이 들어갑니다", date: "0000.00.00", isPinned: false, opensDetail: false),
        AnnouncementItem(id: "notice-7", title: "공지사항 제목이 들어갑니다", date: "0000.00.00", isPinned: false, opensDetail: false)
    ]
}
