# A-12 Drawer Menu Parity

- Figma node: `182:2416`, 390 × 852 pt, [A-12 drawer menu frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=182-2416).
- Simulator screenshot: [`A12-drawer-menu.png`](../Screenshots/A12-drawer-menu.png).
- The drawer opens from the Home top bar and overlays Home with a 48% dim. Its panel is 320 pt wide and extends through the system safe areas.

## Implemented

- Close control, brand title/tagline, mock member summary, five Figma navigation rows, Settings and Logout footer.
- The dim background and close control dismiss the drawer. `내 정보` routes to the member My Page; mock `로그아웃` switches to the guest My Page implemented for A-11g.
- Destinations without a screen show an informational notice. The logout vector is imported from Figma; other icons reuse existing Asset Catalog vectors.

## Visual comparison

- Drawer starts below a 52 pt top inset; close control is 44 pt; destination rows are 52 pt; footer is 56 pt with a top divider and 34 pt bottom safe-area inset.
- Panel uses a 320 pt width and shadow; the rest of the screen remains visible under the dim layer.
- The 390 × 852 pt Figma frame and simulator status/home-indicator safe areas differ; this capture is from iPhone 18 Pro.

## Scope limits

- Events, custom quote, customer support, notices and company introduction are not implemented destinations and show a notice.
- Member identity and logout are local mock state only. No server session or authentication request is made.
