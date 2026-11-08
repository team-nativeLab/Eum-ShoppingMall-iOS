# A-28n Password Reset Parity

- Figma frame: `479:5127` (390 × 844 pt)
- Entry point: account lookup → password lookup → `다음`.
- Implementation: SwiftUI `PasswordResetView` and `PasswordResetViewModel`.
- Password visibility and mismatch icons reuse the existing `WithdrawalPasswordVisibility` and `WithdrawalPasswordError` Asset Catalog entries; the back control reuses `ProductDetailBack`.

## Implemented

- Fixed title bar and bottom action with a scrollable form body.
- New password and confirmation fields, visibility toggles, password guidance, mismatch error border/helper, and disabled `변경하기` state.
- The initial sample state intentionally matches the Figma error frame. Password policy is checked locally (at least eight characters with letters and digits); backend reset is out of scope.
- The password lookup screen now advances here. A valid matching pair reaches a notice until Issue #61 adds the completion screen.

## Visual review

- Source layout follows a 20 pt horizontal inset, 16 pt body top inset, 24 pt section spacing, 48 pt fields, 14 pt error icon, and fixed 56 pt bottom action.
- Target-state screenshot and UI hierarchy inspection are blocked because Xcode cannot load the absent `SimulatorKit.framework`. The simulator can run the app, but no UI interaction API is available to navigate into this screen; this limitation will be noted in the PR.
