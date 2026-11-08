# A-25d Quote Inquiry Detail Parity

- Figma frame: `358:4230` (390 × 1391 pt)
- Entry point: quote history → tap the title of an inquiry with status `견적 발송`.
- Implementation: SwiftUI `QuoteDetailView` and `QuoteDetailViewModel`.
- Figma check, paperclip, and download SVGs are stored in the Asset Catalog; product thumbnails use the existing `ProductPlaceholder` asset.

## Implemented

- Fixed top bar, vertically scrolling detail body, and fixed contact/requote actions.
- Four-step progress indicator, quote response and amount, requester information, requested products, request details, and attachment rows.
- Detail content uses the placeholder values shown in the Figma frame. Files, contact, and requote actions show service-integration notices because their back-end behavior is outside this issue.

## Visual review

- Source layout: 20 pt horizontal body inset, 16 pt section spacing, 12 pt card radius, 16 pt card inset, and fixed 48 pt footer buttons.
- Target-state simulator capture could not be verified because Xcode is missing `SimulatorKit.framework`; build/run and test results are recorded in the PR.
