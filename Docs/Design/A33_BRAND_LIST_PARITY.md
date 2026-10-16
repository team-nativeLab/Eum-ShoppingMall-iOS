# A-33 Brand List Parity

## Reference

- Figma: `616:12901` (390 × 1447 pt)
- Brand list content is in the Category tab, with 가나다/ABC indexes, an “All” selection, spotlight brand, search and sort controls, grouped list rows, and the shared tab bar.

## Implemented

- Replaced the Category tab's brand-mode placeholder with the spotlight band, brand search, sort toggle, language/index controls, and grouped 72 pt brand rows.
- Search, index filtering, alphabetical sorting, and index scrolling are connected.
- Used local mock entries (`브랜드 A`–`브랜드 I`) and neutral image placeholders because actual brand data and logo assets are not present in the repository or the Figma frame.
- Brand row and spotlight buttons report the selected mock brand through a callback; the containing Category flow currently leaves detail navigation for issue #79.
- The brand list remains within the existing Category tab and preserves its tab bar and product mode.

## Validation

- SwiftLint strict: 0 violations.
- Tuist generation: passed.
- iPhone 17 Pro simulator build and app launch: passed.
- Simulator tests: 102 passed, 0 failed.
- `git diff --check`: passed.

## Visual capture

Figma node `616:12901` was inspected using Figma design context. A simulator target-route capture is not available because the Xcode UI snapshot tool cannot load `SimulatorKit.framework` in this environment; target-screen visual comparison remains unverified.
