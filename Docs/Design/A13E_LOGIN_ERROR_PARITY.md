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
- Reused existing `LoginInfo`, close icon, and shared color/type/button tokens.
- The 14 pt helper `circle-alert` (`LoginErrorAlert`) and the 20 pt password `trailing-icon` (`LoginPasswordHidden`, eye-off) use the Figma source SVGs (#276). The visible-password state keeps the SF Symbol `eye` because Figma does not define that state.

## Validation

- SwiftLint strict: 0 violations.
- Tuist generation: passed.
- iPhone 17 Pro simulator build and app launch: passed.
- Simulator tests: 96 passed, 0 failed.
- `git diff --check`: passed.

## Visual capture

The Figma frame was inspected through Figma design context. The simulator UI snapshot tool could not load Xcode's `SimulatorKit.framework` in this environment. A `simctl` capture confirmed the app launches to Home, but it did not show the login route, so it is not recorded as a login parity screenshot. Target-screen visual comparison remains unverified.

## Server integration (#293)

- "로그인" calls `POST /api/v1/app/auth/login` through `AppServices.shared` (`AppAuthSession` stores both tokens in the Keychain, with a memory fallback for unsigned simulator builds).
- `LOGIN_FAILED` (401) shows the inline error. The server does not return remaining attempts, so the screen counts failures as `(n/5회)`; the Figma sample `(0/5회)` is kept for the preview state.
- `LOGIN_LOCKED` (429) and `CAPTCHA_REQUIRED` (400) show the server guidance in an alert. CAPTCHA handling is pending a server-side decision.
- Network errors ask the person to check the connection. Success closes the login modal.
- UI tests pass `-ui-test-auth-failure LOGIN_FAILED` (debug only) so CI does not depend on the live server. The live-server failure path was checked locally on 2026-11-28 with an unknown account (`(1/5회)` shown).
