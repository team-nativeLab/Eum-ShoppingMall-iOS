# A-24 Addresses Parity

- Figma frame: `357:4081` (390 × 844 pt)
- Simulator: iPhone 17 Pro, iOS 26.5; capture [`A24-addresses.png`](../Screenshots/A24-addresses.png)
- Entry point: My Page → 배송지 관리
- Implementation: SwiftUI `AddressesView` and `AddressesViewModel`.

## Implemented

- Three address cards; the first is the default address and shows the dark `기본 배송지` badge.
- Non-default cards include 기본 설정, 수정, and 삭제 actions; the default card shows 수정 only.
- Setting a default address updates the local state; deleting an address removes it from the local list.
- The literal address-limit notice and fixed bottom 배송지 추가 button match the frame.

## Visual review

The simulator capture was compared with the Figma frame. Card order, recipient and address placeholders, button placement, default badge, card borders, limit notice, and bottom action follow the inspected design.

The Figma frame says `배송지는 최대 0개까지 등록할 수 있습니다.` while displaying three addresses and an enabled add button. All visible samples and copy are preserved. Address names and contact details remain mock data.

## Scope and limitations

Default selection and deletion are local only. Add/edit buttons are visible but their A-24e destination screen is handled separately; service persistence is not connected.
