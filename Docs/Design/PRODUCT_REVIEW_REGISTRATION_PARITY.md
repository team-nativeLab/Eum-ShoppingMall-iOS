# Product Review Registration Parity

- Figma: [리뷰 등록 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=1101-2145)
- Node: `1101:2145`
- Frame: `390 × 844 pt`
- Data: current product and purchase identity are local mock data. Review submission is not connected to the server.

## Implemented

- Added a review registration route from the product's all-reviews screen.
- Added product summary, purchase verification label, five selectable ratings, review text entry, photo picker, and fixed register action.
- Register stays disabled until a rating and non-empty review are provided. Submit shows a mock completion message and returns to the review list.
- Search opens the existing contextual search route; back returns to the form with its entered state intact.

## Verification

- iPhone 17 Pro / iOS 27.1 Simulator focused UI test: passed; verifies entry, empty-state disabled action, rating and text validation, search round-trip, mock submission, and return paths.
- Simulator screenshots: `../Screenshots/A-review-registration-empty.png` and `../Screenshots/A-review-registration-filled.png`.
- SwiftLint strict and `git diff --check`: passed.
- The simulator frame includes the native status area. The empty form structure, product/purchase cards, rating row, content field, photo action, and fixed bottom button were visually compared with the 390 pt Figma frame. The filled capture also shows the native keyboard.
