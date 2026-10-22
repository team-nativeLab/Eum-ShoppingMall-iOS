# A-05sh Hidden Price Options Sheet Parity

- Figma: [A-05sh 옵션 바텀시트 · 금액 미표시 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1258)
- Node: `180:1258`
- Frame: `390 × 852 pt`
- Data: local sample option values; product inventory and prices are not connected.

## Implemented

- Price inquiry notice uses the Figma danger foreground and pale red background.
- Hidden-price sheet actions use an outlined cart button and a dark quote button.
- Cart action shows its confirmation; quote action opens the quote inquiry screen.

## Verification

- ProductListNavigationUITests: 13 passed, 0 failed; includes cart confirmation and quote inquiry navigation.
- SwiftLint strict: 218 Swift files, 0 violations.
- `git diff --check`: passed.
- Simulator capture: `../Screenshots/A05sh-hidden-options.png`.
