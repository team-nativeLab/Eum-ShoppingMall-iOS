import XCTest
@testable import EumShoppingMall

final class CompanyIntroductionViewModelTests: XCTestCase {
    func testCompanyIntroductionSectionsMatchFigmaContent() {
        let viewModel = CompanyIntroductionViewModel()

        XCTAssertEqual(viewModel.sectionNavigation, ["개요", "사업 분야", "연혁", "인증", "파트너", "오시는 길"])
        XCTAssertEqual(viewModel.heroTitle, "사람이 있는 곳에,\n더 안전한 내일을 연결합니다.")
        XCTAssertEqual(viewModel.overviewTitle, "현장의 안전을 연결하는 회사")
    }

    func testBusinessAreasUseFigmaCopyAndExistingOrExtractedAssets() {
        let viewModel = CompanyIntroductionViewModel()

        XCTAssertEqual(viewModel.businessAreas.map(\.title), ["안전용품 유통", "현장 납품", "맞춤 제작", "안전 컨설팅"])
        XCTAssertEqual(viewModel.businessAreas.map(\.iconName), [
            "CategoryHardHat",
            "CompanyBusinessTruck",
            "CompanyBusinessClothing",
            "CompanyBusinessShield"
        ])
        XCTAssertEqual(viewModel.businessAreas.count, 4)
    }

    func testHistoryAndCertificationKeepFigmaPlaceholderValues() {
        let viewModel = CompanyIntroductionViewModel()

        XCTAssertEqual(viewModel.historyItems.map(\.year), ["0000", "0000", "0000"])
        XCTAssertEqual(viewModel.historyItems.map(\.description), Array(repeating: "00월 연혁 내용이 들어갑니다.", count: 3))
        XCTAssertEqual(viewModel.historyItems.map(\.isHighlighted), [true, false, false])
        XCTAssertEqual(viewModel.certifications.count, 2)
        XCTAssertTrue(viewModel.certifications.allSatisfy { $0.description == "인증 내용이 들어갑니다" })
    }

    func testPartnersAndLocationUseOnlyPlaceholderInformation() {
        let viewModel = CompanyIntroductionViewModel()

        XCTAssertEqual(viewModel.partners, Array(repeating: "파트너 로고", count: 3))
        XCTAssertEqual(viewModel.locationRows.map(\.title), ["주소", "고객센터", "이메일"])
        XCTAssertEqual(viewModel.locationRows.map(\.value), [
            "서울특별시 00구 00로 00, 00빌딩",
            "0000-0000 (평일 00:00 – 00:00)",
            "info@example.com"
        ])
    }
}
