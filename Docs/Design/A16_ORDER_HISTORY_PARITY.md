# A-16 Order History Parity

- Figma frame: `350:3346` (390 × 1114 pt)
- Simulator capture: [`A16-order-history.png`](../Screenshots/A16-order-history.png)
- Entry point: My Page → 주문내역
- Implementation: SwiftUI view and `OrderHistoryViewModel`; the Home modal route owns presentation.

## Implemented

- Header with back navigation and the 취소·반품 action.
- Horizontally scrolling six status filters and a selectable order-period menu.
- Four mock order cards for 입금대기, 결제완료, 배송중, and 배송완료.
- Order detail, cancellation, delivery tracking, and reorder actions are wired to local mock notices.
- Existing `ProductPlaceholder` asset is used for product imagery.
- Empty filter results display a Korean empty message.

## Visual review

The iPhone 18 Pro capture was reviewed against the Figma frame. The header, filter row, period selector, card hierarchy, placeholder image, status badges, and action buttons follow the supplied layout. The screen uses the shared color, typography, spacing, radius, and button APIs. The captured screen continues vertically through the fourth order card as expected.

## Scope and limitations

Orders and dates are placeholders. Selecting a period changes its selected label; it does not filter the static sample data. The status set includes 배송준비 as a filter, while no sample order currently has that status. Cancellation, delivery tracking, reorder, order detail, and returns are not connected to backend services or destination screens.
