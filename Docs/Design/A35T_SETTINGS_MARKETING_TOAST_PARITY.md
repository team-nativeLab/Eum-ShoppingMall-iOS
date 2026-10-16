# A-35t Marketing Consent Toast Parity

- Issue: #83
- Figma: [A-35t Settings, node 655:7579](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=655-7579)
- Frame: 390 × 1248 pt
- Implementation: `SettingsMarketingToast` and marketing state in `SettingsViewModel`

## Structure reviewed

The underlying screen uses the signed-in A-35 Settings layout. Figma shows the marketing app push preference off and a 350 × 68 pt toast at x=20, y=1130. The toast uses 16 pt horizontal and 14 pt vertical padding, a 20 pt white circle-check, 10 pt icon/text gap, 12 pt corner radius, and a shadow at y=4 with radius 16.

## Implemented

- Changing any marketing preference updates its local mock state and displays a bottom toast for three seconds.
- The message identifies the channel and whether consent was given or declined. Turning off app push uses the Figma copy exactly: `0000.00.00 마케팅 앱 푸시 수신 거부가 처리되었습니다.`
- Added the Figma circle-check SVG and the `#222222` toast color token.
- The toast stays above the home indicator, supports VoiceOver as one combined message, and is dismissed when Settings closes.
- Preference state and the date are mock values; no backend persistence is connected.

## Validation

- Tuist generation: passed.
- SwiftLint strict: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator tests: 109 passed, 0 failed, including toast content and dismissal behavior.
- Target-screen screenshot and visual comparison remain unavailable because `SimulatorKit.framework` is missing from the installed Xcode.
