import SwiftUI

struct CartViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            CartView(cartCount: 3, onSelectTab: { _ in })
                .previewDisplayName("A-07 Cart")

            CartView(cartCount: 3, presentation: .mixedPricing, onSelectTab: { _ in })
                .previewDisplayName("A-07h Mixed Pricing")

            CartView(cartCount: 2, presentation: .zeroOrder, onSelectTab: { _ in })
                .previewDisplayName("A-07h2 Zero Orderable Items")
        }
    }
}
