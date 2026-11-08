# A-34 Brand Detail Screen Parity

- Issue: #79
- Figma: [Brand detail, node 616:13032](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=616-13032)
- Reference frame: 390 × 2595
- Implementation: `BrandDetailView` / `BrandDetailViewModel`

## Figma structure reviewed

The screen contains a 56 pt brand top bar, a 534 pt hero and summary, a 465 pt brand story and facts, a 1007 pt product section with category chips and a two-column product grid, a 398 pt other-brand section, and the persistent bottom tab bar. The hero image is the Figma image asset; the logo marks are placeholders in the source design.

## Implemented

- Brand directory rows open the matching detail view; back returns to the directory and selecting another brand changes the detail.
- Hero, story expansion, fact rows, category filtering, sort menu, product cards, favorite forwarding, and other-brand navigation are present.
- “제품 보기” scrolls to the product section. Product taps forward to the existing Home product-detail route.
- The product and brand content is local mock data. Sort and paging labels retain the Figma placeholder counts (`00`); loading more and backend behavior are not connected.
- Added `BrandDetailHero.imageset` from the Figma hero image. Brand logo artwork was not present in the inspected composition and remains a neutral placeholder.

## Validation

- `tuist generate --no-open`: passed.
- `swiftlint lint --strict`: passed with 0 violations.
- iPhone 17 Pro simulator build and launch: passed.
- Simulator test suite: 104 passed, 0 failed.
- Xcode reports two existing Swift 6 actor-isolation warnings in `FavoritesViewModel.swift` and `RecentlyViewedViewModel.swift`.
- Target-screen visual comparison was not captured in this run; the available simulator UI snapshot route fails because `SimulatorKit.framework` is missing in the environment. Build and launch do not establish pixel parity.
