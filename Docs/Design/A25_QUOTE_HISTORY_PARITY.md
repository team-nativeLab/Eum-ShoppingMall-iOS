# A-25 Quote Inquiry History Parity

- Figma frame: `358:4125` (390 × 1011 pt)
- Simulator capture: iPhone 17 Pro, iOS 26.5; [`A25-quote-inquiry-history.png`](../Screenshots/A25-quote-inquiry-history.png)
- Entry point: My Page → 견적 문의 내역
- Implementation: SwiftUI `QuoteHistoryView` and `QuoteHistoryViewModel`.

## Implemented

- Six horizontally scrolling status chips: 전체, 접수, 상담중, 견적 발송, 완료, 취소.
- Five mock inquiry cards with the Figma placeholder dates, numbers, titles, and product counts.
- Status badge treatments and the first card's arrived-quote notice with a document action.
- Fixed 새 견적 문의 button connected to the existing quote inquiry form.
- Status filters update the visible cards; selecting 전체 restores the complete mock list.

## Visual review

The simulator screen was compared with the Figma frame at its 390 pt reference width. Top bar, filter chips, card spacing and border, badge variants, document notice, and fixed bottom action follow the inspected design. The simulator viewport is shorter than the 1011 pt Figma frame, so the cards scroll beneath the fixed action.

## Scope and limitations

Inquiry data is local mock content and retains the Figma's `0000` placeholder values. The document action displays a service integration notice because no quote document is available. There is no inquiry detail design in this frame.
