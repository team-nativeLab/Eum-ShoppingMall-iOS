# A-07 Cart Screen Parity

- Figma node: `180:1780`, 390 × 1025 pt, [A-07 cart frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1780).
- Simulator: iPhone 18 Pro, iOS 27, screenshot at 1206 × 2622 px (402 × 874 pt).
- Screenshot: [`Docs/Screenshots/A07-cart.png`](../Screenshots/A07-cart.png).
- Runtime state: seeded with three mock rows, two selected rows, and one sold-out row to match the Figma sample.

## Implemented

- Cart title and search action, guest login notice, select-all count, and selected-item removal.
- Product rows with placeholder, option label/change action, remove action, quantity stepper, and disabled sold-out state.
- Price summary, fixed order CTA, selected Cart tab, and count badge.
- Mock interactions for selection, quantity changes, removal, search navigation, and order/option notices.

## Visual comparison

- The 56 pt top bar, 20 pt horizontal content inset, 44 pt notice, 138 pt item rows, 112 × 36 pt quantity controls, 20 pt selection boxes, and fixed bottom actions follow the Figma node measurements.
- The same image placeholder and search/tab vectors already present in the asset catalog are reused. The product placeholder is rendered as a 32 pt icon centered in the 80 pt image tile.
- The simulator viewport is 12 pt wider and 151 pt shorter than the Figma frame. The app's native status safe area is 62 pt versus the design's 44 pt status row; the cart content scrolls beneath the fixed order action and tab bar on the shorter device.
- The reference uses sample placeholder prices (`₩00,000`). The implementation preserves them because no price values are specified by this frame.

## Scope limits

- Authentication, product option selection, and checkout are not connected to a backend or other screens. Their controls show a brief informational message.
- The A-07h hidden-price and A-07h2 zero-order variants are separate Figma screens and are not included in this issue.
- The screenshot was captured with a temporary simulator launch argument selecting the Cart tab; that argument was removed from the source before final validation.
