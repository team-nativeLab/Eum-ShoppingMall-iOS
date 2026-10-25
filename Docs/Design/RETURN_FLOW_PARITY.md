# Latest cancel, return and exchange flow (#253)

Figma file: `N3Ic9TfSnUBVMgAuayBVly`. Designs and variables were inspected read-only; the Figma file was not changed.

| Screen | Figma node | Implementation / route | Capture |
| --- | --- | --- | --- |
| A-19c hub | 927:8508 | My Page / order history → hub → orders, history, or order selection | [Hub](../Screenshots/A19c-return-hub.png) |
| A-19s order selection | 929:46104 | Status/period controls, order details, tracking, select order → request | [Selection](../Screenshots/A19s-order-selection.png) |
| A-19a cancellation | 879:44844 | Shared request form: cancellation tab, products, reason, photos, refund notice | [Cancel](../Screenshots/A19a-cancel-request.png) |
| A-19b exchange | 879:44922 | Shared form: photos, option/stock notice, pickup, exchange costs | [Exchange](../Screenshots/A19b-exchange-request.png), [Costs](../Screenshots/A19b-exchange-cost.png) |
| A-19le empty history | 927:44448 | Empty history → orders → back restores empty state | [Empty](../Screenshots/A19le-return-empty.png) |
| A-19l cancellation filter | 927:45466 | Cancellation badge and rejection reason action | [Cancel filter](../Screenshots/A19l-cancel-filter.png) |
| A-19l return filter | 927:45597 | Requested / collecting states, refund row, withdrawal action | [Return filter](../Screenshots/A19l-return-filter.png) |
| A-19l exchange filter | 927:45728 | Exchange complete state; no unrelated refund row | [Exchange filter](../Screenshots/A19l-exchange-filter.png) |
| A-54 rejection reason | 927:45901 | Rejected request → reason screen → back retains history filter | [Reason](../Screenshots/A54-rejection-reason.png) |
| A-50 request received | 879:8904 | Submit a return/cancel/exchange form → receipt number and request guidance → request history | [A-50](../Screenshots/A50-request-complete.png) |
| A-53 withdrawal complete | 879:44682 | Confirm withdrawal → completion summary → request history | [A-53](../Screenshots/A53-withdrawal-complete.png) |
| A-19l after withdrawal | 879:45201 | History keeps the selected filter and shows `철회완료` | [A-19l](../Screenshots/A19l-after-withdrawal.png) |
| A-51 after withdrawal | 879:45279 | Request detail shows withdrawn status, reason, address and application number | [A-51](../Screenshots/A51-withdrawn-detail.png) |

The shared empty-state correction also covers previously implemented A-16e (`927:44328`) and A-20e (`927:44560`): their icon, resolved colors, central placement and CTA are aligned with the current frames, with their existing browse/back paths preserved.

## State and actions

- Uses existing HomeNavigationPath and retained view models. The active request receives the selected order; awaiting-payment/paid orders initially open cancellation, transit/delivered orders initially open return. Tabs remain switchable in this local UI. This initial choice is not server eligibility validation.
- Order history cancellation now opens the request form. The hub and all request/history back buttons return through the existing stack. Selection filters remain when returning from the form.
- Product selection, quantity, reason, details, photo picker/removal, request tabs and pickup choices remain interactive. Address change opens the existing address screen. In Debug, submit and withdrawal update local in-memory sample history to make the designed result routes reviewable. In Release, both actions show the explicit service-unavailable message; neither mode calls a backend or claims a server-side request/refund/exchange.
- Request details and withdrawal continue through their existing screens. Rejection details use the selected item rather than claiming a fabricated backend result or request number.

## Visual implementation

- Exported request and rejection SVGs are local asset catalog files. Native asset dimensions were retained (24 pt back, 14 pt check, 32 pt placeholder, 16 pt stepper/info, 20 pt photo-add, 12 pt photo-remove, 14 pt pickup radio, 20 pt rejection icons).
- Status badge colors and order-selection placeholder geometry follow the inspected designs. Existing design-system typography and controls are reused.
- Resolved Figma variables for the selected frames include `hf/bg=#fafafa`, `hf/surface=#ffffff`, `hf/text-1=#171717`, `hf/text-2=#4a4a4a`. Empty-state colors are scoped to the implemented frames so other app screens retain their existing palette. The five account-empty captures from #252 are refreshed in this change.
- Device status bar/home indicator and viewport height use native iOS behavior. Long Figma frames appear as scrollable content; captures document initial and lower sections separately. Filter captures may include native press feedback immediately after selection.

## Figma completion and withdrawal states (#255)

The refreshed Figma frames A-50 `879:8904`, A-53 `879:44682`, A-19l `879:45201`, and A-51 `879:45279` are now represented by the completion, history, and withdrawn-detail routes. A-50 and A-53 primary actions open the request history while preserving the selected filter. Withdrawal changes the local request badge and detail content. This is a Debug-only local mock; Release retains the unavailable-service message until a backend contract is available.

Simulator captures are checked into `Docs/Screenshots`; they are simulator evidence, not physical-device verification.

## Verification

#255 local verification on iPhone 18 Pro / iOS 27.0 Simulator: 9 request/history unit tests and 4 return-flow UI tests passed; strict SwiftLint and `git diff --check` passed. UI captures include the A-50, A-53, after-withdrawal A-19l, and A-51 states. These checks cover local Debug UI state only, not backend communication or physical-device behavior.

Strict SwiftLint, diff checks, request/history ViewModel tests and account/return UI navigation tests were run. UI coverage includes all three hub routes, cancellation/exchange/return form entry, submit feedback, filtered history, rejection detail, empty history, and back-state restoration. Exact final full-suite and CI outcomes are recorded in the PR. Screenshots are simulator evidence, not physical-device verification. Server communication is outside this change.

Local verification: the full suite passed 193 tests (168 unit + 25 UI). After final visual corrections, the five affected favorites/order-history/return-flow UI tests passed again. The first remote #254 run failed two new account-empty tests because XCTest attempted an AX scroll on a visible back button; those tests now select the hittable back button and tap its center, following the existing route-test convention. The final combined PR closes #252 and #253; its CI result is the final merge gate.

Back-button follow-up: the quote form's actual back label was `뒤로 가기`, while the first test queried another screen's generic back label. Screen-specific back identifiers now target the exact active screen. Common/custom back labels have an explicit 44 pt rectangular hit shape, and UI tests assert that width before tapping the center. The three account-empty tests passed on iPhone 18 Pro / iOS 27 after this correction. An earlier iOS 26.5 attempt passed two tests but its runner ended with SIGTERM on the third; that run is not counted as a pass.
