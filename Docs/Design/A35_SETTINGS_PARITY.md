# A-35 Settings Screen Parity

- Issue: #80
- Figma: [A-35 Settings, node 655:7083](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=655-7083)
- Frame: 390 × 1248 pt
- Implementation: `SettingsView`, `SettingsComponents`, and `SettingsViewModel`

## Structure reviewed

The frame has a 44 pt system status region, a 56 pt top bar, and an 1114 pt vertically scrolling body. The body uses 20 pt horizontal insets, 24 pt top padding, 40 pt bottom padding, and 32 pt gaps between the notification, marketing consent, policy, app information, and account groups. A 34 pt bottom system region contains the home indicator.

## Implemented

- Connected the home drawer's Settings action to the new settings route.
- Added the app push and marketing consent toggles with Figma's initial on/off states and local view state.
- Added the policy links, app version row, logout row, and withdrawal entry. Withdrawal reuses the existing account withdrawal flow.
- Imported the Figma on/off switch and disclosure SVG assets into Asset Catalogs. Reused the existing back icon.
- Policy links and logout currently show a short unavailable message; their dedicated presentation is covered by separate open issues. The marketing-change toast is also deferred to its dedicated issue. Toggle changes remain local mock state.
- Preserved Figma placeholder values `0000.00.00` and `0.0.0 · 최신 버전`.

## Validation

- `tuist generate --no-open`: passed.
- `swiftlint lint --strict`: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator tests: 106 passed, 0 failed.
- Xcode reported existing Swift 6 actor-isolation warnings in `FavoritesViewModel.swift` and `RecentlyViewedViewModel.swift` during build.
- Target-screen screenshot and visual comparison are unavailable in this environment because `SimulatorKit.framework` is missing from the installed Xcode. No pixel-parity claim is made.
