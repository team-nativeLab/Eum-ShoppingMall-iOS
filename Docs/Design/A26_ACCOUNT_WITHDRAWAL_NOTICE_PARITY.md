# A-26 Account Withdrawal Notice Parity

- Figma frame: `458:4210` (390 × 925 pt)
- Simulator capture: iPhone 17 Pro, iOS 26.5; [`A26-account-withdrawal-notice.png`](../Screenshots/A26-account-withdrawal-notice.png)
- Entry point: My Page → 내 정보 관리 → 회원 탈퇴
- Implementation: SwiftUI `AccountWithdrawalNoticeView` and `AccountWithdrawalNoticeViewModel`.

## Implemented

- Member withdrawal title bar, warning introduction, coupon/point loss summary, five notice bullets, agreement checkbox, and fixed disabled/enabled next button.
- Profile edit's 회원 탈퇴 action routes to this notice screen. Back returns to profile edit.
- Agreement starts unchecked and enables the next button after selection.
- Reuses the coupon ticket and coin SVGs from the existing coupon feature.

## Visual review

The iPhone 17 Pro simulator capture was compared against the 390 pt Figma frame. It follows the source layout for introduction, summary card, notice list, agreement control, and fixed bottom action. The iPhone simulator has rounded device corners and a larger device viewport; the body can scroll while the bottom action remains fixed.

## Scope and limitations

This frame's `0년` record retention and `0일` re-registration periods are reproduced as literal Figma placeholders and are not validated legal policy. The displayed member name, coupon count, and points balance are mock values. Continuing after agreement currently reports that the reason selection is the next screen; withdrawal submission is not performed.
