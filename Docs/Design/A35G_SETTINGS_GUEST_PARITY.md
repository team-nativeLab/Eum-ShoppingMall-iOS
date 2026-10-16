# A-35g Guest Settings Screen Parity

- Issue: #81
- Figma: [A-35g Guest Settings, node 655:7269](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=655-7269)
- Frame: 390 × 900 pt
- Implementation: guest state in `SettingsView`

## Structure reviewed

The 44 pt status region and 56 pt top bar are followed by a 766 pt body. The guest body retains the app push notification group, replaces marketing toggles with a 120 pt login guide, keeps policy and app version groups, and omits the signed-in account group. Body spacing and insets reuse A-35.

## Implemented

- Guest users can open Settings from the Guest My Page settings icon or the Home drawer.
- The app push switch and policy/app information sections reuse A-35 components and assets.
- The marketing card explains that sign-in is required to change consent. Its Login button opens the existing authentication flow and returns to Settings when dismissed.
- Logout and account withdrawal controls are hidden in guest mode.
- No new static assets were required; existing A-35 settings vectors, back icon, and shared components are reused.

## Validation

- Tuist generation: passed.
- SwiftLint strict: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator tests: 106 passed, 0 failed.
- Xcode reported the existing Swift 6 actor-isolation warnings in `FavoritesViewModel.swift` and `RecentlyViewedViewModel.swift` during build.
- Target-screen screenshot and visual comparison could not be captured because the installed Xcode is missing `SimulatorKit.framework`. No pixel-parity claim is made.
