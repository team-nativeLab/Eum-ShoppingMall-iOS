# A-26d Withdrawal Complete Parity

- Figma frame: `459:4328` (390 × 844 pt)
- Simulator capture: iPhone 17 Pro, iOS 26.5; [`A26d-withdrawal-complete.png`](../Screenshots/A26d-withdrawal-complete.png)
- Entry point: A-26c confirmation → 탈퇴하기
- Implementation: SwiftUI `AccountWithdrawalCompleteView` and `AccountWithdrawalCompleteViewModel`.

## Implemented

- Completion check icon, title and message, withdrawal/rejoin summary, legal-retention notice, close control, and fixed 홈으로 action.
- The final confirmation mock flow routes to this completion screen. Close and 홈으로 both return to Home.
- Reuses the existing close and info icons; adds the Figma completion check vector.

## Visual review

Compared the iPhone 17 Pro simulator capture with the 390 pt Figma frame. Header, centered completion group, summary rows, inline notice, and fixed home action follow the source composition.

## Scope and limitations

The completion view is a local mock flow; the app does not delete an account or update authentication state. `0000.00.00` dates and the `0년` retention period are literal Figma placeholders, not validated policy or calculated dates.
