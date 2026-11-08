# A-35l Logout Confirmation Parity

- Issue: #84
- Figma: [A-35l Logout Confirmation, node 655:7760](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=655-7760)
- Frame: 390 × 1248 pt
- Implementation: `LogoutConfirmationDialog` presented by `SettingsView`

## Structure reviewed

The dialog is 350 × 178 pt and centered over the signed-in Settings screen. It uses a 48% dark dim layer, a 12 pt white rounded card, 24 pt internal padding, a title/body group, and two 48 pt buttons separated by 8 pt. The dialog shadow follows the Figma y=12/radius=32 token; SwiftUI's shadow API does not expose the negative spread value.

## Implemented

- The Settings logout row opens a custom confirmation dialog.
- Cancel dismisses it and leaves the member signed in.
- Confirm dismisses Settings, changes the mock account state to guest, and opens Guest My Page.
- Reused `EUMButton` for the secondary Cancel and primary Logout actions. No new artwork was required.

## Validation

- Tuist generation: passed.
- SwiftLint strict: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator tests: 109 passed, 0 failed.
- Xcode reported the existing Swift 6 actor-isolation warnings in `FavoritesViewModel.swift` and `RecentlyViewedViewModel.swift` during build.
- Target-screen screenshot and visual comparison were unavailable because `SimulatorKit.framework` is missing from the installed Xcode. No pixel-parity claim is made.
