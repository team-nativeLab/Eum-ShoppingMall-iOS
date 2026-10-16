# A-35p Device Notifications Off Parity

- Issue: #82
- Figma: [A-35p Settings, node 655:7397](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=655-7397)
- Frame: 390 × 1324 pt
- Implementation: permission state and inline notice in `SettingsView` / `SettingsViewModel`

## Structure reviewed

This variant retains the signed-in A-35 groups and inserts a 64 pt inline notice 12 pt below the notification card. That makes the notification section 182 pt tall and shifts the following marketing, policy, app-information, and account groups down by 76 pt compared with A-35.

## Implemented

- Reads `UNUserNotificationCenter` authorization state when Settings appears and refreshes when the app returns active.
- When system notification authorization is unavailable, shows the Figma disabled push switch asset and the inline information notice. Marketing preferences remain independently adjustable.
- “기기 설정 열기” opens this app's Settings page using `UIApplication.openSettingsURLString`.
- Imported the Figma disabled switch and info icon SVGs. Reused the existing on/off switches, chevron, and back assets.

## Validation

- Tuist generation: passed.
- SwiftLint strict: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator tests: 107 passed, 0 failed, including authorization-state mapping.
- Xcode reported the existing Swift 6 actor-isolation warnings in `FavoritesViewModel.swift` and `RecentlyViewedViewModel.swift` during build.
- Target-screen screenshot and visual comparison were unavailable because `SimulatorKit.framework` is missing from the installed Xcode. No pixel-parity claim is made.
