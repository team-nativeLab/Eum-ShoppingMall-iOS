# A-07h2 Cart Zero Orderable Items Parity

- Figma node: `181:1940`, 390 × 1019 pt, [A-07h2 zero-orderable cart](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-1940).
- Simulator: iPhone 18 Pro, iOS 27, screenshots at 1206 × 2622 px (402 × 874 pt).
- Screenshots: [`A07h2-cart-zero-order.png`](../Screenshots/A07h2-cart-zero-order.png) and [`A07h2-cart-zero-order-bottom.png`](../Screenshots/A07h2-cart-zero-order-bottom.png).
- The top capture shows the `0/0` selection state and both quote-only rows. The bottom capture shows the zero-value summary and fixed quote-request CTA.

## Implemented

- Add a zero-orderable presentation with two quote-only products.
- Disable the select-all control and selected-item deletion while keeping per-item removal available.
- Show the quote-products header, explanation, outlined quote badge, inquiry action, inquiry quantity stepper, and `가격 문의` label.
- Display `₩0` for item subtotal, shipping, and expected total; show `담은 상품으로 견적 문의 (2)` in the fixed CTA and a cart badge count of two.
- Add the A-07h2 state to the shared Cart SwiftUI previews.

## Visual comparison

- The cart header and 56 pt selection row use the existing A-07 components. The unavailable-items group has 24 pt top and 12 pt bottom padding; two quote rows and the summary follow it.
- The 56 pt CTA and five-item tab bar remain fixed while the cart list scrolls.
- The simulator is 12 pt wider and 145 pt shorter than the Figma frame. Separate screenshots capture the upper list and lower summary/CTA state.
- Existing vectors are reused; no new assets or invented product imagery were introduced.

## Scope limits

- Quote submission requires login and is an informational mock action; no request is sent.
- This state is exposed through the shared Cart presentation and SwiftUI preview. The default Cart tab remains on the A-07 sample until repository data selects this state.
- Temporary launch and scroll-anchor arguments used to capture the screenshots were removed before final validation.
