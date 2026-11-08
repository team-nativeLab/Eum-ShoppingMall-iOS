# A-05 Product Detail Parity

- Figma: [A-05 상품 상세 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=179-938)
- Node: `179:938`
- Frame: `390 × 2601 pt`
- Data: local sample content; live product and review APIs are not connected.

## Implemented

- Product-specific brand, title, rating, review count, discount, and current/original prices.
- Product specifications, shipping summary, sample review card, and related products.
- Matching shipping policy values on the detail page and the shipping policy route.
- Favorite state uses a filled heart when selected.
- The latest Figma frame dimensions are recorded in `SCREEN_INVENTORY.md`.

## Verification

- Product navigation UI suite: 12 passed, 0 failed.
- SwiftLint strict: 218 Swift files, 0 violations.
- `git diff --check`: passed.
- Simulator build and launch: passed on iPhone 17 Pro.
- Simulator captures: `../Screenshots/A05-product-detail-top.png`, `../Screenshots/A05-product-detail-specifications.png`, `../Screenshots/A05-product-detail-shipping-reviews.png`, and `../Screenshots/A05-product-detail-lower-sections.png`.

## 2026-11-08 buy bar position review (#260)

- Removed the extra transparent 34 pt spacer below the fixed action row. The native home-indicator safe area already supplies the system-bar space shown below the Figma action area.
- Kept the Figma 12 pt bottom padding and 56 pt action buttons. The iPhone 18 Pro / iOS 27.0 simulator capture shows the heart, cart and buy buttons aligned at the bottom of the product detail viewport: `../Screenshots/A05-product-detail-buybar-ios27.png`.
- The long Figma frame is 390 × 2601 pt and the simulator viewport is 402 × 874 pt. This confirms the fixed-bar placement and visible button geometry; it is not a pixel-for-pixel comparison of the full scrolling page.
