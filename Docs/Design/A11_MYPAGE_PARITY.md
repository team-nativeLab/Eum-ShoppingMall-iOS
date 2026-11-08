# A-11 My Page Parity

- Figma node: `181:2409`, 390 × 955 pt, [A-11 My Page frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-2409).
- Simulator screenshot: [`A11-my-page.png`](../Screenshots/A11-my-page.png).
- Uses the existing five-item bottom tab bar with `마이` selected. Header, account overview, order status and menu content follow the Figma section hierarchy.

## Implemented

- Mock member name/type/greeting and four shortcuts for orders, favorites, recently viewed products and coupons.
- Five zero-count order states and seven account/support menu rows.
- Imported the screen's Figma SVG icons into the Asset Catalog and recorded them in the asset inventory.
- The gear, profile, quick-menu and account rows provide clear notices because their destination screens are not in the current implementation scope.

## Visual comparison

- Profile region is 112 pt high; shortcut area is 82 pt; order status card is 76 pt; menu rows are 56 pt with 20 pt horizontal inset.
- The member profile icon uses a 72 pt circular surface. The order-status and menu containers use a 12 pt corner radius and the shared neutral tokens.
- The 390 × 955 pt Figma frame is displayed on iPhone 18 Pro with native status and home-indicator insets; the content scrolls above the existing fixed tab bar.

## Scope limits

- Member identity, order counts and all account data are mock values. Account management, order history, address management, claims, inquiries, support and notices destinations are not implemented by this issue.
