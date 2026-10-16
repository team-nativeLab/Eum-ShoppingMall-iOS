# A-32 Notifications Parity

- Figma frame: `480:5502` (390 × 844 pt)
- Entry point: Home notification bell.
- Implementation: SwiftUI `NotificationsView` and `NotificationsViewModel`.
- Delivery, quote, contact, order, notice, and unread-dot SVGs are stored as vector assets. The top-bar back control reuses `ProductDetailBack`.

## Implemented

- Fixed top bar and unread summary, scrollable Today/Previous Notifications sections, type icons, metadata, unread styling/dot, and fixed retention note.
- Five local sample notifications match the visible Figma copy. Tapping a row marks that notification read; `모두 읽음` marks all read and updates the count.
- The notification bell now opens this screen. Notification content and read status are local mock data; service-specific routing is outside this issue.

## Visual review

- Source layout follows a 56 pt top bar, 20 pt horizontal row insets, 40 pt icon tiles with 20 pt icons, 12 pt row gap, 16 pt vertical row padding, and 12 pt footer padding.
- The Figma header says `읽지 않은 알림 0개` while two Today rows have the documented unread style and dot. The implementation derives the count from those rows and starts at 2, so the count agrees with the displayed read state.
- Target screenshot and UI hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator interaction. Build/test evidence will be recorded in the PR.
