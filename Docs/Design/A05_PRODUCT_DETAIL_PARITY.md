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
