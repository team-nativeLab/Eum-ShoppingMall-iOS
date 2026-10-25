# Figma Audit

- Source: [06 Design — App](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=178-345), read-only.
- Audited page node: `178:345`; the original 88-frame inventory was refreshed on 2026-10-26 with newer inquiry, event, policy, request-completion and withdrawal-state frames. See `SCREEN_INVENTORY.md` for the node-by-node list.
- Detail contexts and screenshots were obtained for A-01 Splash (`178:350`) and A-02 Home (`178:369`). The splash screenshot is the visual target; the page tree is the source for the remaining inventory.
- Figma MCP variable-definition and Code Connect library listing were unavailable on the connected seat. Do not treat fallback colors in generated code as confirmed published variables.

## Structure and behavior evidence

- Splash: 390 × 852 pt; top status treatment 44 pt; bottom home indicator 34 pt. Background image fills the frame with a dark vertical overlay.
- Home: 390 × 1701 pt design frame; system top 44 pt, top bar 56 pt, body 1510 pt, bottom tab bar 91 pt. Sections include search, hero, category strip, recommended horizontal product rail, best-seller grid, and quote banner. Its content exceeds the visible device viewport and scrolls vertically; the recommended products scroll horizontally.
- Fixed-looking top and bottom bars are separate page-tree instances. Runtime pinning behavior should be checked on device during publishing.
- Metadata shows empty-result and error-like frames, including search empty state, cart pricing variants, FAQ/notice/notification empty states, and login/profile error states. The page tree does not define a complete transition graph; navigation must be verified from prototypes or interaction details.
- No loading-state design was confirmed in inspected metadata.

## Audit limits

Screen numbers are not unique across the latest page: A-43 identifies both company introduction and 1:1 inquiry; A-54 identifies both events and rejection reason. Node IDs disambiguate them. The newly inspected return states are A-50 `879:8904`, A-53 `879:44682`, A-19l after withdrawal `879:45201`, and A-51 after withdrawal `879:45279`.

The component dependency graph and exhaustive variant/state values remain incomplete: Code Connect listing reports an Organization/Enterprise seat requirement. Published tokens could not be read by the variable tool. Only values present in A-01/A-02 high-fidelity context and page metadata are documented; unknown values stay uncommitted.

## Related files

- [Screen inventory](SCREEN_INVENTORY.md)
- [Component inventory](COMPONENT_INVENTORY.md)
- [Design tokens](DESIGN_TOKENS.md)
- [Asset inventory](ASSET_INVENTORY.md)
