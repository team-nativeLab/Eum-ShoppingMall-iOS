# A-23e Profile Edit Parity

- Figma frame: `357:3977` (390 × 1231 pt)
- Simulator: iPhone 17 Pro, iOS 26.5; capture [`A23e-profile-edit.png`](../Screenshots/A23e-profile-edit.png)
- Entry point: My Page → profile → password confirmation → 내 정보 수정
- Implementation: SwiftUI `ProfileEditView` and `ProfileEditViewModel`.

## Implemented

- Basic information fields for email, name, and phone; email is disabled and phone has a change action.
- Password-change menu row with Figma key icon and chevron.
- Business section with editable company/department fields, disabled registration number, and helper copy.
- SMS/email agreement checkboxes and the order/delivery notification note.
- Member withdrawal link and fixed bottom save action.
- Password-confirmation screen now advances on any non-empty password in this mock flow.

## Visual review

The simulator capture was compared with the Figma frame. Section order, input states, business section, checkbox defaults, notice, withdrawal link, and fixed save action follow the inspected layout. The device viewport is shorter than the 1231 pt frame, so the form scrolls beneath the pinned save action.

## Scope and limitations

All profile details are mock values. Password confirmation, phone change, save, password-change, and withdrawal actions are not backed by account services. Any non-empty password advances only to demonstrate the mock navigation; this is not credential verification and must be replaced by the account service before production use. The Figma screen shows business information together with a note that it is only displayed for business members; the literal frame is preserved for visual parity.
