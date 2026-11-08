# A-14 Signup Parity

- Figma node: `182:2601`, 390 × 1104 pt, [A-14 signup frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=182-2601).
- Simulator capture: [`A14-signup.png`](../Screenshots/A14-signup.png). The 390 × 1104 design frame is taller than the iPhone viewport, so the form scrolls above the fixed bottom action.
- The A-13 signup link opens this screen; the top back action returns to login.

## Implemented

- Personal member form with email, password and confirmation, name, phone and verification code, agreement rows, helper copy, and fixed signup action.
- Password rule requires at least eight characters with an English letter and a digit. Required terms and privacy agreements gate the button; marketing consent is optional.
- Selecting email check or phone verification follows a local mock path. The sample phone code is `123456`; editing the email or phone clears its previous mock verification.
- Agreement details and final account creation display notices because those services/screens are not connected.

## Scope limits

- The business-member variant is a separate Figma frame (`558:5787`, A-14b, Issue #76); this A-14 issue implements the personal-member frame only.
- No email uniqueness lookup, SMS delivery, countdown service, legal document, or account session is connected.
