# A-27z Email Lookup Empty Parity

- Figma frame: `479:4854` (390 × 844 pt)
- Entry point: A-27 email lookup with verified but unmatched mock details.
- Implementation: SwiftUI `EmailLookupEmptyView`.
- The search-x and close vectors reuse `SearchEmpty` and `ProductOptionClose` from the Asset Catalog.

## Implemented

- Empty-state icon, no-match title and helper, fixed retry and sign-up actions, and the account-finding top bar.
- A verified mock lookup with details that do not match the sample account routes here. “다시 찾기” returns to A-27, and “회원가입” opens the existing sign-up flow.

## Visual review

- Figma uses a 64 pt light-gray icon tile with 28 pt search-x, 18 pt title, 14 pt helper, and two fixed 56 pt bottom buttons.
- Target-state simulator screenshot remains unavailable because Xcode is missing `SimulatorKit.framework`; build and test results will be included in the PR.
