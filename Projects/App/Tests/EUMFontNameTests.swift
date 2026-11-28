import UIKit
import XCTest
@testable import EumShoppingMall

final class EUMFontNameTests: XCTestCase {
    func testEveryFontNameResolvesToBundledNotoSansKR() throws {
        for name in EUMFontName.all {
            let font = try XCTUnwrap(UIFont(name: name, size: 14), "\(name) is not registered")
            XCTAssertEqual(font.familyName, "Noto Sans KR")
        }
    }

    func testWeightsIncreaseFromRegularToBold() throws {
        func weight(_ name: String) throws -> CGFloat {
            let font = try XCTUnwrap(UIFont(name: name, size: 14))
            let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            return try XCTUnwrap(traits?[.weight] as? CGFloat)
        }

        let regular = try weight(EUMFontName.regular)
        let medium = try weight(EUMFontName.medium)
        let bold = try weight(EUMFontName.bold)
        XCTAssertLessThan(regular, medium)
        XCTAssertLessThan(medium, bold)
    }
}
