# A-19 Return Request Parity

- Figma frame: `353:3555` (390 × 1539 pt)
- Simulator capture: [`A19-return-request.png`](../Screenshots/A19-return-request.png)
- Entry point: My Page → 주문내역 → 주문 상세 → 교환·반품 신청
- Implementation: SwiftUI view and `ReturnRequestViewModel`.

## Implemented

- Return/cancel/exchange selector, selected-product rows, quantity controls, return reason choices, and a 500-character detail field.
- Photo picker with local thumbnail previews and removal controls; the initial state follows the two example thumbnails in the Figma frame.
- Pickup-method selector, address summary, refund summary, inline notice, and fixed bottom submission action.
- Reuses the product placeholder and shared button/color APIs, with local SVG exports for the checkbox, selected radio, add-photo, remove-photo, and minus controls.
- Order detail return/exchange action opens this screen. Back navigation returns to that order detail.

## Visual review

The iPhone simulator capture was reviewed against the Figma frame. The visible viewport confirms the top bar, selector, product rows, reason list, detail field, and fixed bottom action. The frame extends below the initial simulator viewport; photo, pickup, and refund sections were matched to the measured Figma layout in code but are not visible in this single capture.

## Scope and limitations

Order data and initial photo thumbnails are mock presentation data. Photo selection and removal work locally. Address changes, alternative cancel/exchange flows, and return submission are not connected to backend services; tapping unavailable flows or submit displays explanatory local feedback.
