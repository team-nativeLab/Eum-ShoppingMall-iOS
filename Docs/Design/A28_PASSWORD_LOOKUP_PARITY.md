# A-28 Password Lookup Parity

- Figma frame: `479:4974` (390 × 844 pt)
- Entry point: login → account lookup → password lookup tab; the email result screen also links to the password lookup tab.
- Implementation: SwiftUI `PasswordLookupView` and `PasswordLookupViewModel`.
- The verified state uses the Figma sample email and phone values. The Figma circle-check SVG is stored in `PasswordLookupVerified.imageset`; the existing `ProductDetailBack` asset supplies the matching 24 pt back control.

## Implemented

- Fixed account lookup top bar and bottom `다음` action around the scrollable form.
- Email field, disabled verified phone/code controls, disabled resend/confirm buttons, selected password tab, and verified helper state.
- Email is editable and validated locally. The backend and SMS verification are out of scope; the screen opens in the verified sample state shown by Figma.
- The next action currently reports that password reset is the next screen task (#60); the navigation will be connected when that screen is implemented.

## Visual review

- Source layout follows the 20 pt horizontal inset, 16 pt body top inset, 24 pt section gaps, 48 pt fields, 56 pt primary action, and fixed bottom safe-area action in the Figma frame.
- The app built, installed, and launched on iPhone 17 Pro. Target-state capture and UI hierarchy inspection could not run: Xcode reports `Failed to load essential private frameworks` because `SimulatorKit.framework` is missing. `simctl` could capture the running Home screen, but no interaction API is enabled here to navigate into account lookup; this is not treated as target-screen visual verification.
