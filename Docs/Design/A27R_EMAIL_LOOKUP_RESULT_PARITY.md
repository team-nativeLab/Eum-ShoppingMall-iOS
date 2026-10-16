# A-27r Email Lookup Result Parity

- Figma frame: `479:4725` (390 × 844 pt)
- Entry point: A-27 email lookup with a matching mock account.
- Implementation: SwiftUI `EmailLookupResultView` and `EmailLookupResultViewModel`.
- The close, check, and information icons reuse existing Asset Catalog entries (`ProductOptionClose`, `WithdrawalComplete`, and `LoginInfo`).

## Implemented

- Success icon, result heading and helper, masked email, join date, member badge, privacy notice, and fixed login/password-lookup actions.
- The found address is masked by preserving the first two local-part characters and the domain, matching the Figma sample `ex***@email.com`.
- A-27's matching sample lookup now opens this result; the login button returns to login. Password lookup remains in its separate publishing issue.

## Visual review

- Source spacing: 20 pt horizontal inset, 48 pt body top inset, 24 pt group/card spacing, 64 pt success icon, and 56 pt fixed actions.
- Target-state simulator screenshot remains unavailable because Xcode is missing `SimulatorKit.framework`; the app build and tests are recorded in the PR.
