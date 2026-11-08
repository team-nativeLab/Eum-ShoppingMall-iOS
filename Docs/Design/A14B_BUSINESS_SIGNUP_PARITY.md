# A-14b Business Sign-up Parity

## Reference

- Figma: `558:5787` (390 × 1900 pt)
- Business information subsection: `558:5934`
- Figma displays a selected Business Member segment, a verified sample registration number, account email matching enabled, and no selected certificate.

## Implemented

- Connected the existing Personal/Business member segment to the form state.
- Added business registration number confirmation, company name, representative name, business type, tax invoice email, account email matching, certificate selection, and the inline business review notice.
- The certificate picker accepts image and PDF files and displays the selected filename. The file is not sent to a server.
- Business registration confirmation and the existing email/phone verification codes remain local mock states; no backend requests are made.
- Required business fields and a selected certificate participate in the signup button enabled state.
- Kept the Figma placeholder copy `최대 00MB` and `영업일 기준 0일` verbatim because the design does not supply actual limits or review duration.
- Split the existing signup ViewModel and business information section into separate Swift files to keep source files within project lint limits.

## Validation

- SwiftLint strict: 0 violations.
- Tuist generation: passed.
- iPhone 17 Pro simulator build and app launch: passed.
- Simulator tests: 98 passed, 0 failed.
- `git diff --check`: passed.

## Visual capture

Figma nodes `558:5787` and `558:5934` were inspected through Figma design context. The simulator UI snapshot tool cannot load Xcode's `SimulatorKit.framework` in this environment. `simctl` confirmed the app launches, but the app opened Home and the target signup route was not captured; visual comparison remains unverified.
