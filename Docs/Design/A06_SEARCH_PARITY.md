# A-06 Search Screen Parity

- Figma frame: [A-06 검색 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1374), 390 × 844 pt.
- Simulator: iPhone 18 Pro, iOS 27.0, 402 × 874 pt.
- Capture: [A06-search.png](../Screenshots/A06-search.png).
- The capture build selected the Search tab as its initial tab using a temporary compile condition. That condition was removed after capture; the committed app opens on Home and reaches Search through its tab or Category search button.

## Comparison

- The search header, back and cancel actions, recent-search title and clear action, wrapping recent-search chips, divider, two-column popular-search list, and fixed bottom tab bar follow the Figma frame's hierarchy and arrangement.
- The simulator frame is 12 pt wider and 30 pt taller than the Figma frame. Its native top safe area is taller, so content begins lower than the Figma reference. The bottom system area also differs by device.
- Recent and popular terms are local mock content. Search result and no-result screens are separate frames and are outside issue #20; no prototype transition was confirmed for this frame.

## Verification

- `swiftlint lint --strict`: passed, 0 violations across 29 Swift files.
- iOS Simulator build: passed. `Project.swift` leaves `ASSETCATALOG_COMPILER_APPICON_NAME` empty because the repository has no `AppIcon` asset set.
- App launch and Search screen capture: verified on iOS 27.0. Scene manifest configuration was added to `Project.swift` because the built app otherwise failed to launch under the current SDK.
