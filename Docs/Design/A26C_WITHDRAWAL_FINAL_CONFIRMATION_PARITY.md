# A-26c Withdrawal Final Confirmation Parity

- Figma frame: `459:4287` (390 × 852 pt)
- Simulator capture: iPhone 17 Pro, iOS 26.5; [`A26c-withdrawal-final-confirmation.png`](../Screenshots/A26c-withdrawal-final-confirmation.png)
- Entry point: A-26r reason/password form → 탈퇴하기
- Implementation: confirmation overlay in SwiftUI `AccountWithdrawalReasonView`.

## Implemented

- Dimmed background overlay and centered confirmation dialog.
- Warning icon, irreversible-action copy, coupon and points impact summary, 취소 and destructive 탈퇴하기 actions.
- Cancel closes the overlay and leaves the reason form in place.
- Final action closes the dialog and reports that the withdrawal service is not connected.
- Reuses the existing coupon ticket/coin vectors; adds the Figma red alert-circle SVG.

## Visual review

Compared the iPhone 17 Pro simulator capture with the Figma frame, including the dimmed reason screen behind the dialog. Dialog width, spacing, warning treatment, impact box, action order, and destructive button color follow the inspected design.

## Scope and limitations

The Figma uses `0장` and `0원` as sample impact counts; they remain mock values. No account deletion request is sent. The underlying reason/password fields remain visual mock inputs until a withdrawal service and actual reason taxonomy are specified.
