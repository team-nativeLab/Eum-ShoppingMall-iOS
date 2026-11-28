import SwiftUI
import UIKit

/// PostScript names registered by the bundled `NotoSansKR-Variable.ttf`.
/// The variable font exposes its named instances as `NotoSansKR-Thin_<Weight>`;
/// static-font names such as `NotoSansKR-Bold` do not resolve on iOS.
enum EUMFontName {
    static let regular = "NotoSansKR-Thin_Regular"
    static let medium = "NotoSansKR-Thin_Medium"
    static let semibold = "NotoSansKR-Thin_SemiBold"
    static let bold = "NotoSansKR-Thin_Bold"

    static let all = [regular, medium, semibold, bold]
}

enum EUMTypography {
    static let displayLarge = Font.custom(EUMFontName.bold, size: 44, relativeTo: .largeTitle)
    static let heading2 = Font.custom(EUMFontName.bold, size: 22, relativeTo: .title2)
    static let heading3 = Font.custom(EUMFontName.bold, size: 18, relativeTo: .title3)
    static let bodyExtraLarge = Font.custom(EUMFontName.regular, size: 18, relativeTo: .body)
    static let bodyMedium = Font.custom(EUMFontName.regular, size: 15, relativeTo: .body)
    static let bodySmall = Font.custom(EUMFontName.regular, size: 14, relativeTo: .callout)
    static let labelLarge = Font.custom(EUMFontName.medium, size: 16, relativeTo: .headline)
    static let labelMedium = Font.custom(EUMFontName.medium, size: 14, relativeTo: .subheadline)
    static let labelExtraSmall = Font.custom(EUMFontName.medium, size: 11, relativeTo: .caption2)
    static let captionRegular = Font.custom(EUMFontName.regular, size: 12, relativeTo: .caption)
    static let captionMedium = Font.custom(EUMFontName.medium, size: 12, relativeTo: .caption)
    static let overline = Font.custom(EUMFontName.medium, size: 11, relativeTo: .caption)

    static func uiFont(named postScriptName: String, size: CGFloat, textStyle: UIFont.TextStyle) -> UIFont {
        let baseFont = UIFont(name: postScriptName, size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }
}
