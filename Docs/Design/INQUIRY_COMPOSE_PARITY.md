# Contact and product inquiry screens

Figma file: `N3Ic9TfSnUBVMgAuayBVly`. These designs were inspected read-only.

| Screen | Figma node | Implementation | Simulator capture |
| --- | --- | --- | --- |
| A-43 contact inquiry | `879:8767` | Type, title, content, up to five photos, fixed submit action | [A-43](../Screenshots/A43-contact-inquiry-ios27.png) |
| A-44 product inquiry | `879:8789` | Selected product, content, private-post setting, fixed submit action | [A-44](../Screenshots/A44-product-inquiry-ios27.png) |
| A-45 inquiry receipt | `879:8811` | Pending status, guidance, inquiry-history action | [A-45](../Screenshots/A45-inquiry-complete-ios27.png) |

The compose and completion headers use the Figma left-aligned title placement. The content editor shows the corresponding Figma placeholder until text is entered. Product inquiry omits a title field and uses the product name as its record title; the product name is supplied by the originating detail screen. The private-post field keeps its tap action and accessibility state while following the text-only Figma control.

The submitted record and receipt are local sample state. Contact inquiry requires a type, title and message; product inquiry requires a message. Photo selection is a native picker. No remote inquiry service is connected.

Verification: two focused UI tests passed on iPhone 18 Pro / iOS 27.0 Simulator, covering both compose routes and the receipt route. Captures are simulator evidence, not physical-device verification.
