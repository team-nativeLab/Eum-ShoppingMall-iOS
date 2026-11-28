# A-03 category directory

Figma file: `N3Ic9TfSnUBVMgAuayBVly`; frame `178:722`.

The default product directory was compared to the Figma frame and captured on iPhone 18 Pro / iOS 27 Simulator: [A-03 capture](../Screenshots/A03-category-directory-ios27.png). The segmented control now follows the outlined white container and dark selected state; category icon tiles use the Figma size, border, radius and shadow. The eight category labels, row heights, all-products link, search action and tab bar are present. The category row action was exercised in the focused UI test.

All eight category SVGs are now the original 24 pt vectors exported from this Figma frame. The category rows use those vector assets directly; SF Symbol substitutes and the partial local paths have been removed. The row sizes, labels, navigation and tile treatment remain aligned with the frame.

Verification: `CategoryParityUITests.testCategoryDirectoryMatchesFigmaAndOpensCategoryProducts` passed on iPhone 18 Pro / iOS 27.0 Simulator. Its attached `A03-category-directory` capture was compared against the Figma frame after the vector replacement.
