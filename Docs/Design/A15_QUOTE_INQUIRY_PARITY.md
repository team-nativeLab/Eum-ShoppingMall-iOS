# A-15 Quote Inquiry Parity

- Figma node: `182:2696`, 390 × 1777 pt, [A-15 quote inquiry frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=182-2696).
- Simulator capture: [`A15-quote-inquiry.png`](../Screenshots/A15-quote-inquiry.png). The design frame exceeds the iPhone viewport; the form scrolls above the fixed bottom action.
- Entry points: Home custom-order banner, drawer `맞춤 제작·견적 문의`, and product detail quote actions. A selected product is carried into the inquiry summary.

## Implemented

- Intro headline and four-step process strip, inquiry-product summary, four inquiry types, prefilled mock member fields, desired delivery date picker, delivery area, 1,000-character detail field, local file selection, required privacy agreement, and fixed submit action.
- Product add/remove uses local mock data. Attachment selection uses the system file picker and displays file names locally.
- The submit action remains disabled until the product list and required member/contact fields are valid and privacy consent is selected.

## Scope limits

- No quote service, member profile, file upload, or legal document endpoint is connected. Prefilled company/contact values and product option/quantity are mock data.
- The Figma attachment note does not specify supported formats or size limits; the UI keeps its source copy and accepts file-picker items without an invented limit.
