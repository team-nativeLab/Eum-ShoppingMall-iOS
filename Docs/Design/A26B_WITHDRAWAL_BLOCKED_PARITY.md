# A-26b Withdrawal Blocked Parity

- Figma frame: `467:4358` (390 × 1069 pt)
- Entry point: My Page → 내 정보 관리 → 회원 탈퇴, when the mock order history contains in-progress orders.
- Implementation: SwiftUI `AccountWithdrawalBlockedView` and `AccountWithdrawalBlockedViewModel`.
- Figma source: [A-26b 회원 탈퇴 · 탈퇴 불가](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=467-4358)

## Implemented

- Withdrawal title bar, member intro, coupon/points summary, active-order notice, order-history link, withdrawal notices, disabled agreement row, and fixed disabled next action.
- The order-history link opens the existing order-history route. Back returns to profile editing.
- Reuses existing design tokens, coupon icons, info icon, chevron, back control, and shared disabled button.
- The blocked order count is derived from the local order-history mock items whose status is not delivered.

## Figma review

The inspected frame is 390 × 1069 pt and uses a vertical body with a fixed bottom action area. The screenshot's `0건`, `0년`, and `0일` values are placeholders. The implementation keeps the legal periods as Figma placeholders and displays the current mock order count, which is 3.

## Scope and limitations

No backend eligibility check or account operation is performed. The current order count is based on local sample data. Figma metadata did not provide prototype transition edges; back and order-history destinations follow the existing app flow and the visible CTA label.
