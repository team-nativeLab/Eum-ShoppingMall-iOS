# A-28d Password Reset Complete Parity

- Figma frame: `479:5277` (390 × 844 pt)
- Entry point: password reset → submit matching valid password.
- Implementation: SwiftUI `PasswordResetCompleteView` with `PasswordResetCompleteViewModel`.
- The success check and close control reuse the existing `WithdrawalComplete` and `ProductOptionClose` Asset Catalog entries.

## Implemented

- Account reset title bar with close action, top-aligned success group, 64 pt dark success circle with 32 pt check, completion copy, and fixed bottom `로그인하기` action.
- Password reset now routes to this screen after the local validation state permits submission. Login returns to the login screen; close exits the authentication flow.
- Backend password persistence is not implemented in this publishing issue.

## Visual review

- Source layout follows the 20 pt horizontal inset, 48 pt body top inset, 24 pt success group gap, and 56 pt fixed bottom action from the Figma frame.
- Target-state screenshot and UI hierarchy inspection are blocked by the missing Xcode `SimulatorKit.framework`; the app build/run is verified separately.
