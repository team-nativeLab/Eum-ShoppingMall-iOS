# A-17 Order Detail Parity

- Figma frame: `351:3440` (390 × 1317 pt)
- Simulator capture: [`A17-order-detail.png`](../Screenshots/A17-order-detail.png)
- Entry point: My Page → 주문내역 → 주문 상세
- Implementation: SwiftUI view and `OrderDetailViewModel`.

## Implemented

- Top bar and order date/number summary.
- Two product rows with delivery badges, placeholder images, options, and prices.
- Shipping address, payment breakdown, total paid, payment method, and expected points cards.
- Transaction document and receipt rows with Figma-exported local SVG icons.
- Fixed delivery-tracking and exchange/return actions.
- Back navigation returns to order history.

## Visual review

The iPhone 18 Pro simulator capture was reviewed against the Figma frame. The screen follows its 44 pt design status inset, 56 pt top bar, 16 pt body inset, 16 pt section spacing, 64 pt product images, rounded bordered cards, and fixed two-button bottom action. The content scrolls beneath the fixed action area on the shorter simulator viewport.

## Scope and limitations

Order number, product details, address, prices, and payment method are mock values. Transaction-document download, receipt display, delivery tracking, and exchange/return submission show service-unavailable guidance until their destination screens and backend services are available.
