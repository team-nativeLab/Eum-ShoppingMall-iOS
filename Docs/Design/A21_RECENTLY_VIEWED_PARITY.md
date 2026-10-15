# A-21 Recently Viewed Parity

- Figma frame: `354:3814` (390 × 1045 pt)
- Simulator: iPhone 18 Pro, iOS 27; capture [`A21-recently-viewed.png`](../Screenshots/A21-recently-viewed.png)
- Entry point: My Page → 최근 본 상품
- Implementation: SwiftUI `RecentlyViewedView` and `RecentlyViewedViewModel`, reusing `EUMProductCard`.

## Implemented

- Top bar with back and 전체 삭제 actions, plus the Figma retention notice.
- Two date groups with four and two product cards, a quote item, and a sold-out item.
- Two-column cards use the observed 169 pt width, 153 pt image, 12 pt column gap, and 20 pt row gap.
- Figma remove X asset on each card; deleting the last item removes its date group. 전체 삭제 clears the local list.
- Product taps route to the existing product detail flow.

## Visual review

The simulator capture was compared with the Figma frame. The first group contains the quote card in slot two. The second group contains the sold-out card followed by a standard priced card. Both date groups use the same placeholder label (`0000.00.00`), so their internal identities are unique rather than derived from the displayed date. The simulator viewport is shorter than the Figma frame; the second group continues below the initial viewport.

The Figma notice literally says `최근 본 상품은 최대 0개까지 보관합니다.` while the frame renders six card instances. The copy is preserved and the six visible instances are represented by mock data.

## Scope and limitations

Product names, dates, and prices are mock content. Removal is local screen state; history persistence and retention policy require a service contract.
