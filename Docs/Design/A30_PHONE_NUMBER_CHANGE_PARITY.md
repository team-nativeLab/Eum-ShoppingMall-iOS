# A-30 Phone Number Change Parity

- Figma frame: `480:4974` (390 × 844 pt)
- Entry point: My Page → edit profile → phone number `변경`.
- Implementation: SwiftUI `PhoneNumberChangeView` and `PhoneNumberChangeViewModel`.
- Current number is supplied by the profile screen. Verification reuses the existing `PasswordLookupVerified` Asset Catalog icon and common EUM button/colors.

## Implemented

- Fixed title bar and bottom action, current-number disabled field, editable new-number field with resend action, code entry/confirm action, and 3-minute timer.
- Initial state follows the Figma frame with an entered phone number, empty code, running `02:59` timer, and disabled bottom action.
- Local mock code is `123456`. Successful verification enables the action and updates the displayed profile number. SMS delivery and account persistence remain outside this publishing issue.
- Replaces the phone-number change placeholder in profile edit; back returns to profile edit.

## Visual review

- Source layout follows a 20 pt horizontal inset, 16 pt body top inset, 24 pt section gap, 16 pt fields gap, 48 pt fields, and 56 pt fixed bottom action.
- Target-state screenshot and UI hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator interaction. Build/test evidence will be included in the PR.
