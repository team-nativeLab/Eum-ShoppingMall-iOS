# A-24e Address Editor Parity

- Figma frame: `357:4147` (390 × 899 pt)
- Simulator: iPhone 17 Pro, iOS 26.5; capture [`A24e-address-editor.png`](../Screenshots/A24e-address-editor.png)
- Entry point: My Page → 배송지 관리 → 배송지 추가 or 수정
- Implementation: SwiftUI `AddressEditorView` and `AddressEditorViewModel`.

## Implemented

- Address name and recipient fields; phone field starts in the frame's invalid `010-0000` error state.
- Disabled postal-code value, address search action, address/detail fields, delivery-request row, and default-address checkbox.
- Fixed bottom save action. A valid phone saves into the shared local address list; editing preserves the address identity.
- Back navigation returns to the address list.

## Visual review

The simulator capture was compared with the Figma frame. The invalid phone border/helper, labels and field order, postal search row, focused detail field, request row, default checkbox, and bottom save action follow the inspected error-state frame.

## Scope and limitations

Address search and delivery-request choices display a service-unavailable message because the frame does not specify the search provider or request choices. Phone validation and saved addresses are local mock state. The Figma design provides this invalid-phone state, so the initial phone value intentionally starts invalid.
