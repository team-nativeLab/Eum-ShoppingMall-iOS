# A-03 category directory

Figma file: `N3Ic9TfSnUBVMgAuayBVly`; frame `178:722`.

The default product directory was compared to the Figma frame and captured on iPhone 18 Pro / iOS 27 Simulator: [A-03 capture](../Screenshots/A03-category-directory-ios27.png). The segmented control now follows the outlined white container and dark selected state; category icon tiles use the Figma size, border, radius and shadow. The eight category labels, row heights, all-products link, search action and tab bar are present. The category row action was exercised in the focused UI test.

Four category SVGs in the local asset catalog contain only tiny partial paths (for example, the road icon source is 6.9 × 2.4 pt and the fire icon source is 9.5 × 1.5 pt), which produced visibly broken icons at the design's 24 pt size. Those rows now use matching semantic SF Symbols so the controls render cleanly. These icon silhouettes remain an approximation of Figma's exact vectors; Figma's temporary asset URL could not be fetched from this environment. The remaining small visual gap is recorded rather than treated as pixel-exact parity.

Verification: `CategoryParityUITests.testCategoryDirectoryMatchesFigmaAndOpensCategoryProducts` passed on iPhone 18 Pro / iOS 27.0 Simulator.
