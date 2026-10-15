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

The simulator capture was compared with the Figma export. Card sizes, image placeholder, filled hearts, quote/sold-out variants, top bar, and sort row follow the inspected frame. The Figma frame displays six card instances while its count label reads `전체 0개`; the implementation preserves that literal label. The iPhone viewport is shorter than the Figma frame, so the last row continues below the initial viewport.

## Scope and limitations

Product data is mock content and favorite changes remain in local screen state. The Figma frame covers the initial list state; edit selection and delete controls are local behavior added to make the visible edit action usable. Favorite persistence and product availability require a service.
