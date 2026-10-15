import SwiftUI
import UIKit

enum EUMTypography {
    static let displayLarge = Font.custom("NotoSansKR-Bold", size: 44, relativeTo: .largeTitle)
    static let heading2 = Font.custom("NotoSansKR-Bold", size: 22, relativeTo: .title2)
    static let heading3 = Font.custom("NotoSansKR-Bold", size: 18, relativeTo: .title3)
    static let bodyExtraLarge = Font.custom("NotoSansKR-Regular", size: 18, relativeTo: .body)
    static let bodyMedium = Font.custom("NotoSansKR-Regular", size: 15, relativeTo: .body)
    static let bodySmall = Font.custom("NotoSansKR-Regular", size: 14, relativeTo: .callout)
    static let labelLarge = Font.custom("NotoSansKR-Medium", size: 16, relativeTo: .headline)
    static let labelMedium = Font.custom("NotoSansKR-Medium", size: 14, relativeTo: .subheadline)
    static let labelExtraSmall = Font.custom("NotoSansKR-Medium", size: 11, relativeTo: .caption2)
    static let captionMedium = Font.custom("NotoSansKR-Medium", size: 12, relativeTo: .caption)
    static let overline = Font.custom("NotoSansKR-Medium", size: 11, relativeTo: .caption)

    static func uiFont(named postScriptName: String, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let baseFont = UIFont(name: postScriptName, size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }
}
