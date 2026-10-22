# A-05h Hidden Price Product Detail Parity

- Figma: [A-05h 상품 상세 · 금액 미표시 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=179-1109)
- Node: `179:1109`
- Frame: `390 × 2413 pt`
- Data: local sample content; live product APIs are not connected.

## Implemented

- `금액 미표시` badge and `평점 없음` label for unrated products.
- Pink price inquiry notice with danger color and icon.
- Main detail bar exposes both `장바구니 담기` and `견적 문의` actions.
- Both actions open the existing options sheet; its distinct cart and quote actions remain intact.

## Verification

- ProductListNavigationUITests: 13 passed, 0 failed; includes cart confirmation and quote inquiry from the options sheet.
- SwiftLint strict: 218 Swift files, 0 violations.
- `git diff --check`: passed.
- Simulator capture: `../Screenshots/A05h-hidden-price-top.png`.
