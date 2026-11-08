# A-27 Email Lookup Parity

- Figma frame: `479:4567` (390 × 844 pt)
- Entry point: login → 이메일 찾기.
- Implementation: SwiftUI `EmailLookupView` and `EmailLookupViewModel`.
- The phone verification component uses the design system's existing button, text, and color tokens; no new image asset is needed.

## Implemented

- Account-finding tabs, title and helper copy, name field, phone number and resend row, six-digit verification field, confirmation action, 3-minute countdown, support message, and disabled/enabled fixed CTA.
- The frame's initial mock name, phone number, and 02:59 timer are preserved.
- Mock verification code is `123456`; the mock account returns `example@email.com` only for the Figma sample name and phone. Replace this behavior with account and phone-verification services when available.
- Password lookup tab and result destinations remain for their separate publishing issues.

## Visual review

- Source spacing: 20 pt horizontal inset, 24 pt section spacing, 48 pt input/button rows, 56 pt fixed CTA, 32 pt bottom body padding.
- The app builds and launches on iPhone 17 Pro; target-state screenshot and rendered comparison remain unverified because Xcode is missing `SimulatorKit.framework`, which prevents UI hierarchy capture.
