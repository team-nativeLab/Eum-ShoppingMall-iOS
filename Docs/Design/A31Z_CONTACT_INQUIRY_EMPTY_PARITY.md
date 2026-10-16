# A-31z Contact Inquiry Empty State Parity

- Figma frame: `480:5262` (390 × 844 pt)
- Entry point: My Page → `1:1 문의 내역` when the service has no inquiry records.
- Implementation: empty state within `ContactInquiryHistoryView`, driven by an empty `ContactInquiryHistoryViewModel` record set.
- Reuses the exact existing `SearchEmpty` search-x SVG and existing back/button tokens.

## Implemented

- Hides list filters and cards when there are no inquiry records.
- Adds the 64 pt surface icon container, 28 pt search-x icon, title, two-line description, and fixed `1:1 문의하기` action.
- Adds an empty-state Preview fixture. The populated list remains the default mock state from Issue #64.

## Visual review

- Source layout follows the 20 pt horizontal inset, 80 pt body inset, 64 pt top spacing within the empty-state component, 64 pt icon container, 20 pt icon-to-title gap, and 56 pt fixed action.
- Target-state simulator screenshot and hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator interaction. Build/test evidence will be recorded in the PR.
