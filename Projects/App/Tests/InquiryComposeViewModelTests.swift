import XCTest
@testable import EumShoppingMall

final class InquiryComposeViewModelTests: XCTestCase {
    @MainActor
    func testContactInquiryRequiresTypeTitleAndContent() {
        let viewModel = InquiryComposeViewModel(context: .contact)
        XCTAssertFalse(viewModel.canSubmit)

        viewModel.inquiryType = "상품"
        viewModel.title = " 문의 제목 "
        viewModel.content = " 문의 내용 "

        XCTAssertTrue(viewModel.canSubmit)
        let record = viewModel.makeRecord(id: "contact-test", date: "2026.10.19")
        XCTAssertEqual(record.category, "상품")
        XCTAssertEqual(record.title, "문의 제목")
        XCTAssertEqual(record.content, "문의 내용")
        XCTAssertEqual(record.summary, "문의 내용")
        XCTAssertEqual(record.status, .pending)
    }

    @MainActor
    func testProductInquiryDefaultsToProductTypeAndPreservesPrivacy() {
        let viewModel = InquiryComposeViewModel(context: .product(name: "보호 장갑"))
        XCTAssertEqual(viewModel.inquiryType, "상품")
        XCTAssertFalse(viewModel.canSubmit)

        viewModel.title = "사이즈 문의"
        viewModel.content = "사이즈가 어떻게 되나요?"
        viewModel.isPrivate = true

        let record = viewModel.makeRecord(id: "product-test", date: "2026.10.19")
        XCTAssertTrue(viewModel.canSubmit)
        XCTAssertEqual(record.category, "상품")
        XCTAssertTrue(record.isPrivate)
    }

    @MainActor
    func testAddingInquiryMakesItVisibleAndResetsStatusFilter() {
        let viewModel = ContactInquiryHistoryViewModel()
        viewModel.selectedStatus = .answered
        let inquiry = ContactInquiryRecord(
            id: "new-inquiry",
            date: "2026.10.19",
            category: "상품",
            status: .pending,
            title: "새 문의",
            summary: "내용",
            relatedOrderNumber: "0000000000",
            content: "내용",
            attachmentName: nil,
            answerDate: nil,
            answer: nil
        )

        viewModel.add(inquiry)

        XCTAssertEqual(viewModel.selectedStatus, .all)
        XCTAssertEqual(viewModel.visibleInquiries.first?.id, "new-inquiry")
    }
}
