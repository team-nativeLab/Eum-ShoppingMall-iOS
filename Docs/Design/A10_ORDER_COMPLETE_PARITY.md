# A-10 Order Complete Parity

- Figma node: `181:2335`, 390 × 844 pt, [A-10 order completion frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-2335).
- Simulator screenshot: [`A10-order-complete.png`](../Screenshots/A10-order-complete.png).
- The screen uses the shared three-step checkout progress with all steps complete, a centered confirmation, mock order summary, and two fixed bottom actions.

## Implemented

- Show the order-complete header, confirmation mark, mock order number, payment amount/method and shipping address.
- Connect A-09's mock payment action to this screen. Close and `쇼핑 계속하기` return to Home; `주문 상세 보기` explains that the detail flow is not implemented.
- Reuse the existing checkout progress component and EUM buttons, colors and typography.

## Visual comparison

- Confirmation icon uses a 64 pt dark circle. Its heading follows the Figma 22 pt bold style; supporting order number uses the 15 pt body style.
- The order summary uses the subtle surface, 12 pt radius and 20 pt inset. The two 56 pt actions remain fixed at the bottom.
- The 390 × 844 pt Figma frame is taller than the iPhone 18 Pro safe-area content region; the simulator capture reflects the device's status and home-indicator areas.

## Scope limits

- Order number, amount, payment method and address are mock values. Tapping the A-09 CTA does not charge a payment or create a backend order.
- Order details are not present in the implemented screen inventory; that action currently shows an informational notice.
