# A-20 Favorites Parity

- Figma frame: `354:3685` (390 × 945 pt)
- Simulator: iPhone 18 Pro, iOS 27; capture [`A20-favorites.png`](../Screenshots/A20-favorites.png)
- Entry point: My Page → 찜한 상품
- Implementation: SwiftUI screen and `FavoritesViewModel`, reusing `EUMProductCard`.

## Implemented

- Two-column six-card grid with the Figma 169 pt card width, 153 pt image, 12 pt column gap, and 20 pt row gap.
- Figma selected-heart SVG, product placeholder, quote badges and pricing, and sold-out overlay states.
- Recent, low-price, and high-price sort choices; heart tap removes an item locally.
- Edit mode supports selecting cards and removing the selection locally.
- Tapping a product opens its product detail screen.

## Visual review

The simulator capture was compared with the Figma export. Card sizes, image placeholder, filled hearts, quote/sold-out variants, top bar, and sort row follow the inspected frame. The Figma frame displays six card instances while its count label reads `전체 0개`; the implementation now shows the actual local product count so removal stays consistent. The iPhone viewport is shorter than the Figma frame, so the last row continues below the initial viewport.

## Scope and limitations

Product data is mock content and favorite changes remain in local screen state. The Figma frame covers the initial list state; edit selection and delete controls are local behavior added to make the visible edit action usable. Favorite persistence and product availability require a service.

## A-20e empty state (#250)

- Figma: `927:44560` (390 × 1065 pt). Reached by removing all favorites or deleting the last selected products.
- Uses the exported 28 pt Figma icon inside the 64 pt surface circle, exact title/body, and active 48 pt 상품 둘러보기 button.
- Empty state hides count/sort. 상품 둘러보기 opens the existing 전체 제품 list; its back button restores the empty favorites screen.
- Favorite changes remain local and are not persisted across leaving/reopening favorites.
- Focused UI coverage removes all six favorites, checks the CTA, opens products, and returns to the empty screen.

- Verification: SwiftLint strict and FavoritesViewModelTests (5 tests) passed; FavoritesNavigationUITests (1 test) passed on iPhone 17 Pro / iOS 26.5. Capture: [A20e-favorites-empty.png](../Screenshots/A20e-favorites-empty.png).
