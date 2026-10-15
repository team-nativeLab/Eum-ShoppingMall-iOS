# A-26r Withdrawal Reason Parity

- Figma frame: `458:4379` (390 × 844 pt)
- Simulator capture: iPhone 17 Pro, iOS 26.5; [`A26r-withdrawal-reason.png`](../Screenshots/A26r-withdrawal-reason.png)
- Entry point: A-26 withdrawal notice → 동의 → 다음
- Implementation: SwiftUI `AccountWithdrawalReasonView` and `AccountWithdrawalReasonViewModel`.

## Implemented

- Six two-column reason options, with the Figma's initial 기타 selection.
- Conditional other-reason text input with a 200-character limit and live count.
- Current-password input with visibility toggle, helper text, and fixed withdrawal action.
- Back navigation returns to the A-26 warning; the warning agreement is retained while navigating.
- The A-26 next action now routes to this screen.

## Visual review

Compared the iPhone 17 Pro simulator capture with the 390 pt Figma frame. The title and intro, two-column reason controls, other-detail field and count, password confirmation, and fixed bottom action follow the source composition.

## Scope and limitations

Figma displays five generic `탈퇴 사유` labels and a selected `기타` option, so the generic labels are reproduced verbatim rather than replaced with guessed business reasons. `입력한 내용`, the six-character count, and masked password are visual mock values copied from the frame. Password verification and withdrawal submission are not connected; tapping the final action shows a service integration notice.
