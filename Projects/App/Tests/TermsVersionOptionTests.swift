import XCTest
@testable import EumShoppingMall

final class TermsVersionOptionTests: XCTestCase {
    func testPickerContainsFourVersionsInDesignOrder() {
        XCTAssertEqual(TermsVersionOption.allCases, [.upcoming, .current, .previous, .older])
        XCTAssertEqual(TermsVersionOption.allCases.map(\.title), [
            "0000.00.00 시행 예정",
            "0000.00.00 시행 (현재)",
            "0000.00.00 시행",
            "0000.00.00 시행"
        ])
        XCTAssertTrue(TermsVersionOption.upcoming.showsPlannedBadge)
        XCTAssertFalse(TermsVersionOption.current.showsPlannedBadge)
    }

    func testCurrentAndPreviousScreensSelectTheirMatchingVersion() {
        XCTAssertTrue(TermsVersionOption.current.isSelected(for: .current))
        XCTAssertTrue(TermsVersionOption.current.isSelected(for: .revisionScheduled))
        XCTAssertTrue(TermsVersionOption.previous.isSelected(for: .previous))
        XCTAssertFalse(TermsVersionOption.older.isSelected(for: .previous))
    }
}
