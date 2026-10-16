# A-36 Terms Screen Parity

- Issue: #85
- Figma: [A-36 Terms, node 656:7470](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=656-7470)
- Frame: 390 × 2978 pt
- Implementation: `TermsView` and `TermsDocument`

## Structure reviewed

The screen has a 56 pt fixed top bar and a vertically scrolling document body. The body uses 20 pt side insets, 24 pt top and section spacing, and 40 pt bottom padding. It contains the effective date and previous-version control, a 24-article contents card, five chapters, and an addendum. The top back control reuses `ProductListBack`.

The Terms row in Settings opens this screen. Its previous-version control opens the A-36v version selector (node `657:7796`); issue #90 owns that sheet and its selection routes. The contents card is static in the supplied Figma frame and has no confirmed prototype interaction.

## Content and assets

- Preserved the 24 article titles and five chapter titles from the Figma instance data.
- Article text is placeholder copy in Figma (`조항 내용이 들어갑니다.`); no legal copy was invented.
- Preserved the two sample clause lists and addendum copy shown by the Figma component instances.
- Added the exact 16 × 16 version-chevron and 20 × 20 contents-chevron SVG assets from Figma.

## Validation

- The app launched in the iPhone 17 Pro simulator, but a Terms screen capture and direct visual comparison could not be completed. Xcode MCP accessibility capture fails because `SimulatorKit.framework` is missing, and its Simulator app opening action cannot find an application named `Simulator`; the available screenshot was of Home, not Terms.
- See the PR and CI checks for Tuist generation and SwiftLint; local simulator build and tests are recorded separately from those CI results.
- No pixel-parity claim is made.
