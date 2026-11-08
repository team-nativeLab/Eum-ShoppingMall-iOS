# A-19l Return History Parity

- Figma frame: `353:3725` (390 × 1006 pt)
- Simulator: iPhone 18 Pro, iOS 27; capture [`A19l-return-history.png`](../Screenshots/A19l-return-history.png)
- Entry points: My Page → 취소·반품·교환 내역; 주문내역 → 취소·반품
- Implementation: SwiftUI view, card/filter components, and `ReturnHistoryViewModel`.

## Implemented

- Four filter chips: 전체, 취소, 반품, 교환.
- Four mock request cards matching the Figma states: 반품요청, 회수중, 교환완료, 반려.
- Each card includes order date and number, request kind, product placeholder, price/quantity, and expected refund amount.
- Request detail and withdrawal actions show local service-unavailable feedback; rejection reason opens the mock reason text.
- The shared product placeholder is rendered at 32 × 32 pt over the Figma 64 × 64 pt gradient tile.

## Visual review

The simulator screenshot was reviewed against the Figma frame. The top bar, 36 pt filter chips, 12 pt card spacing, 16 pt card insets, 64 pt product tiles, and card action rows follow the measured layout. The simulator is shorter than the 1006 pt frame, so the fourth card continues below the initial viewport and remains scrollable.

## Scope and limitations

Request data and rejection reason are mock values. Filtering works locally. Request detail, request withdrawal, live refund amounts, and service updates require backend integration.
