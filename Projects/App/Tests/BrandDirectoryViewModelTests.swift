import XCTest
@testable import EumShoppingMall

@MainActor
final class BrandDirectoryViewModelTests: XCTestCase {
    func testDefaultDirectoryGroupsMockBrandsByFigmaSections() {
        let viewModel = BrandDirectoryViewModel()

        XCTAssertEqual(viewModel.visibleSections, ["ㄱ", "ㄷ", "A–Z"])
        XCTAssertEqual(viewModel.brands(in: "ㄱ").count, 4)
        XCTAssertEqual(viewModel.brands(in: "ㄷ").count, 3)
    }

    func testIndexAndSearchFilterTheDirectory() {
        let viewModel = BrandDirectoryViewModel()
        XCTAssertFalse(viewModel.hasBrands(for: "ㄴ"))
        viewModel.selectIndex("ㄷ")
        XCTAssertEqual(viewModel.filteredBrands.map(\.name), ["브랜드 E", "브랜드 F", "브랜드 G"])

        viewModel.searchText = "브랜드 F"
        XCTAssertEqual(viewModel.filteredBrands.map(\.id), ["brand-f"])
    }

    func testLanguageChangeResetsIndexAndSortCanBeReversed() {
        let viewModel = BrandDirectoryViewModel()
        viewModel.selectIndex("ㄷ")
        viewModel.selectLanguage(.latin)

        XCTAssertEqual(viewModel.selectedIndex, "전체")
        XCTAssertEqual(viewModel.visibleSections, ["A–Z"])

        viewModel.toggleSortOrder()
        XCTAssertFalse(viewModel.isAscending)
        XCTAssertEqual(viewModel.filteredBrands.first?.name, "브랜드 I")
    }
}
