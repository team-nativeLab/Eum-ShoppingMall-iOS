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
}
