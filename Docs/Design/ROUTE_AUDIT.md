# Published Screen Route Audit

Audit date: 2026-10-16
Figma page: `06 Design — App` (`178:345`)

## Scope

The Figma page contains 88 screen frames, including visual and error/empty-state variants. The page metadata does not provide a complete prototype transition graph, so this audit records links supported by the existing screens and app structure. It does not treat every frame as a separate destination.

## Connected paths

| Entry | Destination / result | Notes |
|---|---|---|
| Home search submit | Search results | Carries the entered query into the local mock results UI; the mock catalog does not guarantee query matching. |
| Home hero action | Company introduction (`A-43`) | Back returns to Home; Drawer entry returns to the Drawer. |
| Home category | Product list (`A-04`) | Custom-order category opens Quote Inquiry (`A-15`). The current mock product model has no category field, so category-specific filtering is not represented yet. |
| Home recommended / best-seller “more” | Product list (`A-04`) | Passes the corresponding local mock collection. |
| Home product card | Product detail (`A-05` / `A-05h`) | Opens the selected mock product. |
| Product detail related product card | Product detail for the selected related mock product | Back returns to the previous product detail. |
| Product-list search | Search (`A-06`) | Uses the shared search tab. |
| Product-detail cart icon | Cart (`A-07`) | Opens the Cart tab. The share icon presents the native share sheet with the product title. |
| Product-detail “바로 구매” | Checkout address (`A-10`) | Closes the options sheet and continues through the existing checkout flow. |
| Cart product title / option change | Product detail | Uses the cart item’s local placeholder data. |
| Cart quote action | Quote Inquiry (`A-15`) | Prefills the cart item where available. |
| My Page settings / profile / recent products | Settings (`A-35`) / account verification and profile (`A-23`, `A-23e`) / Product detail | Existing destinations are reused. |
| Drawer customer support / notices | Customer Center (`A-42`) / Notices (`A-40`, `A-41`) | Notice detail returns to the notice list; support contact history opens `A-31`. |
| Usage Guide customer-support action | Customer Center (`A-42`) | Uses the published support screen. |
| Order list delivery tracking | Delivery tracking (`A-18`) | Uses the selected sample order. |
| Checkout completion order details | Order detail (`A-17`) | Uses the matching local payment-method sample. |
| Checkout order-detail back | Checkout completion (`A-11`) | Returns to the originating completion screen; order-history details return to the order list. |
| Checkout / return-request address change | Address management (`A-24`) | Return-request flow returns to the originating request after address selection. |

## Not connected to another published screen

- Drawer Events and Settings Open Source Licenses have no matching destination frame in the 88-frame inventory.
- Product detail shipping-policy detail, a separate full review list, and product-inquiry composition have no separate destination frame. The Product Detail tabs already scroll to its shipping, review, and inquiry sections.
- Product-list filter conditions have no audited filter destination. The current mock products also carry no category assignments, so category-specific results cannot be represented yet.
- Contact-inquiry composition and address search have no matching screen in the inventory.
- Social sign-in, verification-code delivery, order cancellation/reorder/receipts/downloads, and customer-center calling need provider, backend, file, or verified contact details. These remain service integrations rather than screen-routing gaps.
- Delivery-request selection values are not defined in the inspected Figma metadata; no options were invented.

## Validation boundary

`tuist generate --no-open` succeeded. `swiftlint lint --strict` reported 0 violations across 194 files. The iPhone 18 Pro / iOS 27.0 Simulator build succeeded, and XCTest passed 136 tests with 0 failures. Runtime interaction confirmed Home → Product Detail → options → Checkout Address and checkout back → Product Detail. Earlier route checks confirmed the Home hero, search results, Product List/Detail/Cart, and Usage Guide → Customer Center → Contact History back path. The Home screenshot confirms the top content begins below the status area and the tab bar stays above the bottom safe area. This is representative route evidence; it is not a full traversal of every route or a pixel-parity claim.
