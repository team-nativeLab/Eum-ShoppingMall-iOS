# A-29 Password Change Error Parity

- Figma frame: `480:4806` (390 × 844 pt)
- Entry point: My Page → edit profile → password change.
- Implementation: SwiftUI `PasswordChangeView` and `PasswordChangeViewModel` in the My Page feature.
- Password visibility, mismatch/validation icons, and back control reuse `WithdrawalPasswordVisibility`, `WithdrawalPasswordError`, `PasswordLookupVerified`, and `ProductDetailBack` assets already in the project.

## Implemented

- Fixed title bar, scrollable three-field form, fixed `변경하기` action, current-password error style, new-password guidance, and matching confirmation helper.
- The default sample state has an incorrect current password and matching, policy-valid new passwords, matching the Figma error screen. The CTA is enabled as shown.
- Local mock accepts `Current123` for the current password. Submitting another value repeats the mismatch message; a match reports that server integration is still needed. Password persistence is out of scope.
- Replaces the password-change placeholder in profile edit with this screen; the back action returns to profile edit.

## Visual review

- Source layout follows a 20 pt horizontal inset, 16 pt body top inset, 24 pt section gap, 16 pt field gaps, 48 pt inputs, 14 pt helper icons, and fixed 56 pt CTA.
- Target capture and hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator UI interaction. Build/test evidence will be recorded in the PR.
