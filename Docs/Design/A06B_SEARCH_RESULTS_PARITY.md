# A-06b Search Results Parity

- Figma frame: [A-06b 검색 결과 · HF](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=180-1511), 390 × 844 pt.
- Simulator: iPhone 18 Pro, iOS 27.0, 402 × 874 pt (1206 × 2622 px capture).
- Capture: [A06b-search-results.png](../Screenshots/A06b-search-results.png).
- Entry: submit a query from the A-06 search screen or select a recent/popular term. The capture used a temporary launch argument to open the same results state; the argument-based preview code was removed before commit.

## Comparison

- The results header, horizontal category chips, result/sort/filter row, two-column product grid, quote-product badge, and fixed bottom navigation follow Figma node `180:1511`.
- Reused `EUMProductCard`, `EUMTabBar`, and existing back, search, grid, favorite, placeholder, and tab assets. Added the Figma circle-x, arrow-up-down, and 16 × 16 pt filter SVG assets to the Asset Catalog.
- The screenshot exposed that the shared product placeholder was scaling to fill each product image. It now renders at the Figma 32 × 32 pt size over the existing placeholder gradient with its source gray color preserved.
- Figma is 390 × 844 pt; the simulator is 402 × 874 pt. The wider frame shows a different amount of the horizontally scrolling category chips. The native top safe area is taller than Figma's 44 pt system bar, shifting the content below the top bar downward; the bottom tab bar remains anchored above the system home-indicator region.

## Mock behavior and limits

- This screen displays four local mock products. The fourth is presented as a quote product to match the Figma state. Product names, prices, category counts, and result count remain Figma placeholder values; this screen does not query a backend.
- Category chips update their selected appearance. The filter menu filters priced and quote products; the sort menu exposes the project list's current sort choices. Prototype interaction edges for this frame were unavailable, so these controls are mock interactions rather than confirmed server behavior.
- The app's accessibility hierarchy could not be captured because the installed Xcode is missing `SimulatorKit.framework`; visual review used simulator screenshots instead.

## Verification

- `tuist generate --no-open`: passed.
- `swiftlint lint --strict`: passed, 0 violations.
- `xcodebuild test -workspace EumShoppingMall.xcworkspace -scheme EumShoppingMall -destination 'platform=iOS Simulator,id=2AA5B084-D480-4D16-B95D-3A524ACBEF88' CODE_SIGNING_ALLOWED=NO`: passed, 3 tests, 0 failures.
- XcodeBuildMCP simulator build and launch on iOS 27.0: passed; results-screen screenshot captured and reviewed against the Figma frame.
