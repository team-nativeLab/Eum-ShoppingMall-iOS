# A-26r-pw Withdrawal Password Error Parity

- Figma frame: `467:4461` (390 × 844 pt)
- Entry point: A-26 withdrawal notice → reason screen → submit an invalid password.
- Implementation: error state in SwiftUI `AccountWithdrawalReasonView` and `AccountWithdrawalReasonViewModel`.
- Figma source is read-only; the 14 × 14 circle-alert SVG was exported to the app asset catalog.

## Implemented

- Keeps the existing reason selection, detail field, password visibility control, and fixed bottom action.
- An invalid password shows the 1.5 pt danger border and the Figma helper text with its alert icon.
- Editing the password clears the error state; a valid mock password continues through the existing confirmation and completion flow.
- The mock accepts `password`, matching the existing eight-character sample value. This is presentation-only behavior and must be replaced by account-service verification when that service exists.

## Visual review

- Figma frame: 390 pt wide, 844 pt high; body uses 20 pt horizontal inset, 32 pt vertical group spacing, and a fixed 56 pt bottom action.
- Error field: 48 pt high, 14 pt horizontal inset, 8 pt corner radius, 1.5 pt danger border; helper uses 14 pt alert icon and 12 pt caption text.
- The target state could not be captured: XcodeBuildMCP `snapshot_ui` failed because the installed Xcode is missing `SimulatorKit.framework`. The app built and launched on iPhone 17 Pro; rendered parity remains unverified.
