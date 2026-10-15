# A-06z Search Empty State Parity

- Figma frame: [A-06z 검색 결과 없음 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1681), 390 × 844 pt.
- Simulator: iPhone 18 Pro, iOS 27.0, 402 × 874 pt (1206 × 2622 px capture).
- Capture: [A06z-search-empty.png](../Screenshots/A06z-search-empty.png).
- Mock empty query: `방폭 헬멧`. Submitting it from A-06 or A-06b displays this state. A temporary launch argument selected this same state for capture and was removed before commit.

## Comparison

- The screen reuses the search results header and bottom tab bar. The empty state follows Figma's 64 pt surface tile with the 28 pt search-x icon, 64/32 pt vertical insets, title and two-line guidance, and 160 × 48 pt secondary action.
- The quote prompt uses the Figma 12 pt rounded subtle surface, 20 pt insets, 16/4 pt text grouping, and full-width 48 pt secondary button.
- Added the Figma `search-x` vector to the Asset Catalog; the remaining visible search/header/tab assets are reused from existing catalog entries.
- Simulator size is 402 × 874 pt versus Figma's 390 × 844 pt. The native top safe area is taller than the Figma 44 pt system bar, shifting content below the header slightly. The bottom tab bar remains above the simulator home-indicator area.

## Mock behavior and limits

- This screen's local mock no-results condition matches the Figma sample query `방폭 헬멧`; other submitted queries continue to show the four mock results from A-06b. No backend search is connected.
- “인기 검색어 보기” returns to the A-06 search landing screen. The “견적 문의하기” button is present visually but is not routed; the estimate inquiry destination is a later screen (A-15, Issue #34), and a prototype transition was not available in the inspected frame.
- Accessibility hierarchy capture is unavailable because the installed Xcode lacks `SimulatorKit.framework`; the simulator screenshot was captured and reviewed visually.

## Verification

- `tuist generate --no-open`: passed.
- `swiftlint lint --strict`: passed, 0 violations.
- iOS 27 Simulator `xcodebuild test`: passed, 4 tests, 0 failures.
- XcodeBuildMCP simulator build and launch: passed; A-06z screenshot captured and reviewed against Figma.
- `git diff --check`: passed.
