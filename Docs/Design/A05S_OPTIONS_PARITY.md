# A-05s Standard Price Options Sheet Parity

- Figma: [A-05s 옵션 바텀시트 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1142)
- Node: `180:1142`
- Frame: `390 × 852 pt`
- Data: local sample option values; product inventory and prices are not connected.

## Implemented

- The cart action uses the outlined secondary button and shows the cart confirmation.
- The direct purchase action uses the dark primary button and opens the order address screen.
- The option sheet retains the size picker, selected size cards, quantity controls, total, and fixed bottom actions.

## Verification

- `ProductListNavigationUITests`: 13 passed, 0 failed on iPhone 17 Pro / iOS 27.1 Simulator.
- SwiftLint strict: passed, 0 violations.
- `git diff --check`: passed.
- Simulator capture: `../Screenshots/A05s-standard-options.png`.
- The screenshot was compared with the 390 pt Figma frame. The content order and action styling match. The simulator screenshot includes the native status area and is taller than the source frame; the sheet content scales within the device viewport.
