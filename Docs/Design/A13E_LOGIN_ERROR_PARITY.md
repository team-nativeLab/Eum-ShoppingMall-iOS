# A-13e Login Error Parity

## Reference

- Figma: `558:5680` (390 × 844 pt)
- State: invalid password, email `example@email.com`, masked password, error count `0/5회`

## Implemented

- Retained the existing modal top bar, brand notice, keep-signed-in option, account links, and alternate login buttons.
- Added the Figma two-line login-required notice.
- Added a red 1.5 pt password-field border, visibility toggle, and inline mismatch message with the Figma `0/5회` count.
- The regular login flow starts with empty fields. Submitting non-empty credentials displays the designed error state; no authentication backend is called.
- Seeded the SwiftUI preview with the Figma sample email and password so the error state is reviewable.
- Reused existing `LoginInfo`, close icon, and shared color/type/button tokens. The alert and eye glyphs use SF Symbols because no matching local alert/visibility assets were present.

## Validation

- SwiftLint strict: 0 violations.
- Tuist generation: passed.
- iPhone 17 Pro simulator build and app launch: passed.
- Simulator tests: 96 passed, 0 failed.
- `git diff --check`: passed.

## Visual capture

The Figma frame was inspected through Figma design context. The simulator UI snapshot tool could not load Xcode's `SimulatorKit.framework` in this environment. A `simctl` capture confirmed the app launches to Home, but it did not show the login route, so it is not recorded as a login parity screenshot. Target-screen visual comparison remains unverified.
