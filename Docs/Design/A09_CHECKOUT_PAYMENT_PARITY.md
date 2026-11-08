# A-09 Checkout Payment Parity

- Figma node: `181:2204`, 390 × 1175 pt, [A-09 checkout payment frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-2204).
- Simulator screenshot: [`A09-checkout-payment.png`](../Screenshots/A09-checkout-payment.png).
- The screen uses the shared checkout top bar and progress component. Step 1 is complete, step 2 is active, and the pay action remains fixed at the bottom.

## Implemented

- Coupon and points rows, six selectable payment methods, three receipt options, payment breakdown, required agreement control, and disabled/enabled payment CTA.
- The default selections follow the frame: credit card and cash receipt. Coupon and points balances are mock zero values.
- Checkout Address `다음` opens A-09; the back action returns to A-08. Payment selection and agreement state are managed by `CheckoutPaymentViewModel`.

## Visual comparison

- Payment method cards use a 56 pt height, two columns, 8 pt gaps and 8 pt radius. Selected and unselected outlines follow the Figma hierarchy.
- Amount summary uses a subtle surface, 12 pt radius and a stronger final amount row. The payment CTA uses the shared 56 pt button.
- The simulator viewport and operating system safe areas differ from the 390 × 1175 pt design frame; the main content scrolls while the bottom CTA stays fixed.

## Scope limits

- Coupon selection, points use, tax receipt details and payment processing require backend or follow-up flows; the current controls use informational mock behavior where no flow is defined.
- Tapping the enabled mock payment CTA does not charge or create an order. The A-10 completion route is handled in the next issue.
