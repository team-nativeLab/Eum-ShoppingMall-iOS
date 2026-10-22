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
- Empty filter results show a Korean message and product-browsing action.

## Empty state update · A-16e

- Figma frame: `927:44328` (390 × 1114 pt)
- Empty-state capture: [`A16e-order-history-filter-empty.png`](../Screenshots/A16e-order-history-filter-empty.png)
- An actually empty order collection hides the filters and period selector, centers the `SearchEmpty` icon and explanatory copy, and shows the primary `상품 둘러보기` action.
- A filter with no matching orders keeps its selected filters visible and shows the same message and active action below them.
- `상품 둘러보기` opens the existing `전체 제품` list. Back returns to the prior order history and keeps its selected filter.
- UI coverage exercises the empty `배송준비` filter, product list route, return path, and enabled CTA; unit coverage exercises a truly empty order collection.

## Visual review

The iPhone 18 Pro capture was reviewed against the Figma frame. The header, filter row, period selector, card hierarchy, placeholder image, status badges, and action buttons follow the supplied layout. The screen uses the shared color, typography, spacing, radius, and button APIs. The captured screen continues vertically through the fourth order card as expected.

## Scope and limitations

Orders and dates are placeholders. Selecting a period changes its selected label; it does not filter the static sample data. The status set includes 배송준비 as a filter, while no sample order currently has that status. Cancellation, delivery tracking, reorder, order detail, and returns are not connected to backend services.
