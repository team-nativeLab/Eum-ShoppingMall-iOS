# Additional Figma screen checks

Figma file: `N3Ic9TfSnUBVMgAuayBVly`. Frames were inspected read-only and compared with iPhone 18 Pro / iOS 27.0 Simulator captures.

| Screen | Figma node | Implementation and remaining data boundary | Capture |
| --- | --- | --- | --- |
| A-49 all reviews | `879:8887` | Summary, ratings, filters, sorting, review cards and detail return route. Review records and filter results are local examples. | [A-49](../Screenshots/A49-all-reviews-ios27.png) |
| A-54 events | `879:44698` | Figma-sized event cards and status rows; other event cards remain examples. | [A-54](../Screenshots/A54-events-ios27.png) |
| A-55 event detail | `879:44715` | Event information cards and bottom CTA; actual event participation and product mapping are not connected. | [A-55](../Screenshots/A55-event-detail-ios27.png) |
| A-56 marketing information | `879:44734` | Four information cards; content is example copy and opening this page does not change consent. | [A-56](../Screenshots/A56-marketing-consent-ios27.png) |
| A-57 open-source licenses | `879:44754` | Four rows labeled as examples; this is not an inventory generated from the app's resolved dependencies. | [A-57](../Screenshots/A57-open-source-licenses-ios27.png) |

Visual captures document the current simulator layouts. Real review/event records, approved marketing-consent wording, consent persistence, and generated license attribution require their respective service or policy sources.
