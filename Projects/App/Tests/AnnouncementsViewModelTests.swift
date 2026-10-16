import XCTest
@testable import EumShoppingMall

@MainActor
final class AnnouncementsViewModelTests: XCTestCase {
    func testAnnouncementsMatchFigmaPinnedAndRegularRows() {
        let viewModel = AnnouncementsViewModel()

        XCTAssertEqual(viewModel.announcements.count, 7)
        XCTAssertEqual(viewModel.announcements.filter(\.isPinned).count, 2)
        XCTAssertEqual(viewModel.announcements.first?.title, "[공지] 개인정보 처리방침 개정 안내")
        XCTAssertTrue(viewModel.announcements[0].opensDetail)
        XCTAssertFalse(viewModel.announcements[1].opensDetail)
        XCTAssertEqual(
            viewModel.announcements[3].title,
            "공지사항 제목이 들어갑니다. 제목이 길면 두 줄까지 보여 주고 나머지는 말줄임합니다"
        )
    }

    func testEmptyAnnouncementsUseTheDedicatedEmptyState() {
        let viewModel = AnnouncementsViewModel(announcements: [])

        XCTAssertTrue(viewModel.isEmpty)
    }

    func testAnnouncementDetailUsesFigmaPlaceholderCopyAndAttachment() throws {
        let announcement = try XCTUnwrap(AnnouncementsViewModel().announcements.first)

        XCTAssertEqual(announcement.viewCount, "000")
        XCTAssertTrue(announcement.bodyText.contains("공지 본문은 관리자가 작성한 내용으로 서버에서 받아 보여 줍니다."))
        XCTAssertEqual(announcement.attachmentName, "파일명.pdf")
        XCTAssertEqual(announcement.attachmentSize, "0.0MB")
    }
}
