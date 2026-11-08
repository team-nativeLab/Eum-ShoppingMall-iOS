# A-08 Checkout Address Parity

- Figma node: `181:2106`, 390 × 1025 pt, [A-08 checkout address frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=181-2106).
- Simulator: iPhone 18 Pro, iOS 27, screenshots at 1206 × 2622 px (402 × 874 pt).
- Screenshots: [`A08-checkout-address.png`](../Screenshots/A08-checkout-address.png) and [`A08-checkout-address-bottom.png`](../Screenshots/A08-checkout-address-bottom.png).
- A temporary launch argument selected A-08 for the captures; both captures show different scroll positions with the fixed `다음` action.

## Implemented

- Add checkout header and three-step progress with delivery address step active.
- Show the Figma sample default address/contact, delivery request field, standard delivery method, two mock order rows, collapsible product list, and expected total.
- Keep the `다음` button fixed at the bottom and connect the Cart order action to this screen.
- Reuse existing back and disclosure vectors; no new assets were required.

## Visual comparison

- The top bar and section headers follow the Figma 56 pt and 44 pt heights. The request selector uses a 48 pt control; the checkout order CTA uses the 56 pt large button.
- The simulator viewport is 12 pt wider and 151 pt shorter than the design frame. The content scrolls below the fixed CTA; the two screenshots record the top and lower summary positions.
- Address, phone, item names, option labels, and prices remain the sample values shown in Figma.

## Scope limits

- Address editing and delivery request values are not specified by the frame, so their controls show an informational notice instead of inventing options.
- The next payment screen (A-09) is a separate issue. Until that screen is implemented, tapping `다음` shows an informational message.
- Cart, address, shipping, and price data are mock values; no backend or payment service is connected.
