# A-22 Coupons Parity

- Figma frame: `355:3895` (390 × 950 pt)
- Simulator: iPhone 18 Pro, iOS 27; capture [`A22-coupons.png`](../Screenshots/A22-coupons.png)
- Entry point: My Page → 쿠폰함
- Implementation: SwiftUI `CouponsView` and `CouponsViewModel`.

## Implemented

- 56 pt top bar, 48 pt coupon-code field and registration button.
- Points-balance row, two 36 pt coupon tabs, and four coupon tickets.
- Ticket body uses the observed 76 pt scope stub, dotted perforation, 12 pt corners, and Figma ticket/coins SVGs.
- The selected tab filters available versus completed/expired mock data; the latter is empty because the inspected frame contains no completed-coupon examples.
- Registration validates empty input and explains that service-backed registration is unavailable.

## Visual review

The simulator capture was compared with the Figma frame. The coupon order, discount labels, D-0 badge, descriptions, expiry labels, scope labels, perforated ticket edge, and both header controls match the observed content. The iPhone viewport is shorter than the 950 pt design frame, so the fourth ticket continues below the initial viewport.

The Figma tab reads `사용 가능 0` while rendering four coupon tickets. The literal count and visible samples are both preserved. Coupon names, values, conditions, and dates remain placeholders from the design.

## Scope and limitations

Coupon data and the 0 won points balance are mock values. Registration requires a backend contract. The points row is shown as a tappable visual link, but its destination is outside this screen issue; the Figma metadata inspected did not confirm prototype navigation.
