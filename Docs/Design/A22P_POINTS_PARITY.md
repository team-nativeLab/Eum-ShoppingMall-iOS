# A-22p Points Parity

- Figma frame: `355:4019` (390 × 923 pt)
- Simulator: iPhone 17 Pro, iOS 26.5; capture [`A22p-points.png`](../Screenshots/A22p-points.png)
- Entry point: My Page → 쿠폰함 → 보유 적립금
- Implementation: SwiftUI `PointsView` and `PointsViewModel`.

## Implemented

- 56 pt top bar and the Figma balance summary with expiring-points row.
- Four 36 pt filter chips (전체, 적립, 사용, 소멸) filter the six visible history entries.
- History rows show type, date/order-number placeholders, point change, and expiry where present.
- Bottom inline notice reuses the Figma info icon. Back navigation returns to the coupon screen.
- Coupon screen's points-balance row now opens this screen.

## Visual review

The simulator capture was compared with the Figma frame. Balance card, filter order, six history row types, amount alignment, divider rhythm, and usage notice match the inspected initial state. The current iPhone viewport shows all content; values and dates remain the literal placeholders used in Figma.

## Scope and limitations

Balances and history data are mock content. Points persistence, expiration rules, and real order references require a service contract. Filter chips operate on the six local examples.
