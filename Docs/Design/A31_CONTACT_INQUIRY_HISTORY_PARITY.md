# A-31 Contact Inquiry History Parity

- Figma frame: `480:5124` (390 × 844 pt)
- Entry point: My Page → `1:1 문의 내역`.
- Implementation: SwiftUI `ContactInquiryHistoryView` and `ContactInquiryHistoryViewModel`.
- The back control and shared button styles reuse the existing `ProductDetailBack` asset and EUM design system.

## Implemented

- Fixed title bar and bottom `1:1 문의하기` action, scrollable status chips, four sample inquiry cards, and pending/answered badges.
- Filters switch between all, pending, and answered mock records. Dates, category, titles, and summaries use the values shown in Figma.
- The new-inquiry action and card detail action show notices until their respective follow-up screens are implemented. Issue #65 covers the empty state separately.
- Connected the My Page menu item to this screen.

## Visual review

- Source layout follows a 20 pt horizontal inset, 16 pt top inset, 16 pt section gap, 12 pt card gaps, 16 pt card padding, 113 pt card minimum height, and fixed 56 pt bottom action.
- Target screenshot and UI hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator interaction. Build/test evidence will be recorded in the PR.
