# A-36o Previous Terms Screen Parity

- Issue: #86
- Figma: [A-36o Previous Terms, node 656:7779](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=656-7779)
- Frame: 390 × 1383 pt
- Implementation: previous-version variant of `TermsView` and shared `TermsDocument`

## Structure reviewed

The screen reuses the A-36 top bar, terms document header, contents card, and article groups. It changes the header button label to `0000.00.00 시행` and inserts the previous-terms notice between the document header and contents card. The notice uses the existing `LoginInfo` SVG; its SHA-256 matches the Figma icon exactly.

## Interaction scope

- Figma reactions confirm the A-36 current-version and A-36o version buttons both open the A-36v version selector (`657:7796`).
- The `0000.00.00 시행` row in that selector navigates to wrapper `656:7778`, which contains this screen (`656:7779`). Issue #90 owns that selector and its in-app routing.
- The A-36o back control navigates to Settings (`655:7082`). The app uses that target.
- The notice's `현재 약관 보기` text has no Figma prototype reaction; it remains static underlined copy.
- Until issue #90 is implemented, the version buttons show an explanatory message rather than navigating to an unimplemented sheet.

## Content and assets

- Reuses the exact 24 article titles, five chapter titles, sample copy, and addendum from A-36.
- Reuses the exact Figma version and contents chevrons from the A-36 asset catalogs.
- Reuses the existing info icon; no new asset is required.

## Validation

- Simulator capture: [A-36o Terms, iPhone 17 Pro](../Screenshots/A36o-terms-previous.png) (1206 × 2622 px).
- Compared the visible app viewport with the 390 × 1383 pt Figma frame. The top bar, metadata, notice, contents card, article order, and sample copy match. Text row heights were adjusted to Figma's 20/24/26 pt leading. The simulator uses a 402 pt-wide device and native status region, so the vertical offset and status indicators differ slightly; no pixel-perfect claim is made.
- Xcode MCP accessibility hierarchy capture remains blocked because the installed Xcode lacks `SimulatorKit.framework`.
- Tuist generation, strict SwiftLint, simulator build/launch, and unit test results are reported in the PR.
