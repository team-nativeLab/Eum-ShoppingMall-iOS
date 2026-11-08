# Account empty states (#252)

Figma file: N3Ic9TfSnUBVMgAuayBVly. Read-only design inspection; SwiftUI implementation.

| Screen | Figma node | Screenshot | Action |
| --- | --- | --- | --- |
| A-21e | 927:44613 | [Recent](../Screenshots/A21e-recent-empty.png) | 전체 제품 → back retains empty history |
| A-22e | 927:44673 | [Coupons](../Screenshots/A22e-coupons-empty.png) | 전체 제품 → back |
| A-22pe | 927:44782 | [Points](../Screenshots/A22pe-points-empty.png) | 전체 제품 → back |
| A-24e | 927:44885 | [Addresses](../Screenshots/A24e-addresses-empty.png) | 배송지 추가 → back to empty list |
| A-25e | 927:44954 | [Quotes](../Screenshots/A25e-quotes-empty.png) | 새 견적 문의 → back to empty list |

Shared AccountEmptyState follows inspected 64/28 pt icon, 20/8/24 spacing and 48 pt dark green CTA. The exported icon was byte-compared with the existing FavoritesEmpty SVG (identical). Empty lists hide controls that the empty Figma frames omit; empty filtered results keep their filters available. Existing mock samples remain the default. Initializers accept explicit empty data; the debug-only UI fixture makes those actual states testable without changing release behavior.

Verification: strict SwiftLint and 16 existing ViewModel tests plus 3 UI tests passed on iPhone 17 Pro / iOS 26.5. Captures were visually inspected. Native status/home indicator and available viewport height follow the device; Figma frames have varied canvas heights. No server persistence or physical-device verification.

Final resolved Figma colors and refreshed captures are included with #253 in the combined PR: background #fafafa, icon circle #ffffff, title #171717 and description #4a4a4a.
