# A-31d Contact Inquiry Detail Parity

- Figma frame: `480:5375` (390 × 844 pt)
- Entry point: My Page → 1:1 inquiry history → tap an inquiry card.
- Implementation: SwiftUI `ContactInquiryDetailView` and `ContactInquiryDetailViewModel`.
- Back, attachment, and download icons reuse `ProductDetailBack`, `QuoteDetailAttachment`, and `QuoteDetailDownload` assets.

## Implemented

- Fixed `문의 상세` top bar, scrollable status/title/date header, bordered inquiry card, related order and category rows, content, attachment download affordance, and answered-state card.
- Answered samples display the answer timestamp and text; pending samples omit the answer card.
- Card selection now navigates to detail, and the back action returns to the inquiry list. Attachment download reports that file service integration is outside scope.
- Sample inquiry details remain mock data.

## Visual review

- Source layout follows a 20 pt horizontal inset, 16 pt body top inset, 16 pt section gaps, 12 pt card content gaps, 16 pt card padding, and 72 pt detail-label column.
- Target screenshot and UI hierarchy inspection are blocked by missing Xcode `SimulatorKit.framework` and unavailable simulator interaction. Build/test evidence will be included in the PR.
