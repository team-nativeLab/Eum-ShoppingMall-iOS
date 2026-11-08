# A-18 Delivery Tracking Parity

- Figma frame: `351:3570` (390 × 873 pt)
- Simulator capture: [`A18-delivery-tracking.png`](../Screenshots/A18-delivery-tracking.png)
- Entry point: My Page → 주문내역 → 주문 상세 → 배송 조회
- Implementation: SwiftUI view, progress/timeline components, and `DeliveryTrackingViewModel`.

## Implemented

- Top navigation and delivery summary card with 상태·도착 예정일·택배사·송장번호.
- Tracking number copy action writes the mock number to the system clipboard.
- Five-step delivery progress indicator with completed/current/upcoming states.
- Five-entry delivery timeline, order product summary, and delivery delay notice.
- Local Figma SVG exports for check, timeline markers, and info icons; reuses the product placeholder and back icon.
- Added shared `surface-2` and product placeholder gradient colors from Figma evidence to the UIKit/SwiftUI color tokens.

## Visual review

The iPhone 18 Pro simulator capture was reviewed against the Figma frame. The summary card, 40 pt progress row, 59/57 pt timeline graphics, product summary, and inline notice use the measured Figma dimensions and shared tokens. The native status bar and home indicator are supplied by iOS; content honors the Figma 44 pt top inset.

## Scope and limitations

Carrier, tracking number, arrival date, and scan events are placeholder data. Clipboard copying works locally, but live tracking updates and carrier lookups require the shipping service.
