# A-13 Login Parity

- Figma node: `182:2524`, 390 × 844 pt, [A-13 login frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=182-2524).
- Simulator screenshot: [`A13-login.png`](../Screenshots/A13-login.png).
- The A-11g login/signup action now opens this modal login screen; closing it returns to the guest My Page.

## Implemented

- Modal header, brand heading and login-required notice; email/password fields; keep-signed-in toggle; disabled-until-filled login action; account recovery/signup links; two social login actions.
- Email/password are held in a view model. Password input uses `SecureField`; login remains a local mock and displays a notice rather than authenticating.
- Account recovery and social providers display notices because their destination flows are outside this issue. Signup opens A-14.

## Visual comparison

- Uses 20 pt horizontal insets, 24 pt content top padding, 48 pt fields, a 56 pt login button, 48 pt secondary actions, and the shared modal top bar.
- The 390 × 844 pt frame is rendered on iPhone 18 Pro with native status/home-indicator safe areas. The content scrolls when the keyboard or smaller viewport reduces available height.

## Scope limits

- No authentication endpoint, persistent session, recovery form, signup screen, or social provider is connected. Entering values only enables the mock login button.
