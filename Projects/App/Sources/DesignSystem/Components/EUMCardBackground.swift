import SwiftUI

extension View {
    /// Figma card container: `hf/surface` fill with a 1 pt `hf/line` border
    /// (OrderCard, NoticeInline, summary, QuoteCard, CouponTicket, tile, logo-plate, …).
    func eumCardBackground(cornerRadius: CGFloat = EUMRadius.large) -> some View {
        background(EUMColor.surfaceSwiftUI, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(EUMColor.lineSwiftUI, lineWidth: 1)
            }
    }

    /// Figma HF/Segmented track: white fill, 1 pt text-1 outline, 8 pt radius, 4 pt inset.
    func eumSegmentTrack() -> some View {
        padding(4)
            .background(EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.button))
            .overlay(RoundedRectangle(cornerRadius: EUMRadius.button).strokeBorder(EUMColor.text1SwiftUI, lineWidth: 1))
    }

    /// Figma HF/Segmented tab: the selected tab is filled text-1 (pair with inverse text).
    func eumSegmentTabBackground(isSelected: Bool) -> some View {
        background(isSelected ? EUMColor.text1SwiftUI : EUMColor.backgroundSwiftUI, in: RoundedRectangle(cornerRadius: EUMRadius.medium))
    }
}
