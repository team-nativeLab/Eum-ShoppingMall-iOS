# A-07h Cart Mixed Pricing Parity

- Figma node: `181:1738`, 390 × 1174 pt, [A-07h mixed pricing cart](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-1738).
- Simulator: iPhone 18 Pro, iOS 27, screenshots at 1206 × 2622 px (402 × 874 pt).
- Screenshots: [`A07h-cart-mixed-pricing.png`](../Screenshots/A07h-cart-mixed-pricing.png) and [`A07h-cart-mixed-pricing-bottom.png`](../Screenshots/A07h-cart-mixed-pricing-bottom.png).
- The first capture shows the selection bar and priced-product group; the second shows the quote group, price summary, and fixed order action.

## Implemented

- Reuse the A-07 cart view, row, checkbox, quantity stepper, price summary, fixed order CTA, and tab bar.
- Add a mixed-pricing presentation with two selected orderable products and one quote-request product.
- Quote products are excluded from selection count and order quantity. The quote row provides an informational quote action; the group header provides a whole-group quote action.
- Show explanatory copy for products excluded from ordering and the fixed footer notice from the Figma screen.
- Add a second SwiftUI preview for A-07h alongside the A-07 preview.

## Visual comparison

- Figma uses a 56 pt selection row; two 138 pt orderable rows; an unavailable-products group header with 24 pt top and 12 pt bottom padding; one quote row; a 12 pt radius price summary; a fixed order CTA; and the five-item tab bar.
- Existing Figma product placeholder, search, remove, quantity, and tab assets are reused. No new raster or vector asset was needed.
- The simulator is 12 pt wider and 300 pt shorter than the Figma frame. The cart list scrolls under the fixed footer and tab bar. Separate top and lower-scroll screenshots document the full content.
- Sample prices retain the Figma placeholders because no concrete prices appear in this frame.

## Scope limits

- The default Cart tab remains on A-07 sample content; A-07h is a separate Mock presentation and SwiftUI preview. A persistent cart repository will choose the presentation when backend cart data is added.
- Authentication, quote submission, and checkout remain mock informational actions.
- A-07h2 is a separate zero-order cart state and is not part of this issue.
- Temporary launch arguments were used for screenshot capture and were removed before validation.
