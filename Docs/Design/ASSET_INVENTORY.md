# Asset Inventory

Figma source is read-only. Assets below are the only local assets currently confirmed by inspecting the project and matching the splash reference visually.

| Asset | Local path | Source / format | State |
|---|---|---|---|
| Splash background | `Projects/App/Resources/Assets.xcassets/SplashBackground.imageset/splash-background.png` | A-01 photo fill; PNG 768 × 1376 | Present; image matches the Figma A-01 screenshot |
| Noto Sans KR variable font | `Projects/App/Resources/Fonts/NotoSansKR-Variable.ttf` | TTF variable font | Present; family registration/style names still need runtime verification |
| Search icon | `Projects/App/Resources/Assets.xcassets/DesignSearch.imageset/search.svg` | HF/SearchBar vector | Present; 20 × 20 pt |
| Category hard hat | `Projects/App/Resources/Assets.xcassets/CategoryHardHat.imageset/hard-hat.svg` | HF/Icon vector | Present; 24 × 24 pt |
| Hero banner | `Projects/App/Resources/Assets.xcassets/HeroBannerPlaceholder.imageset/hero-banner.png` | HF/HeroBanner ph-3 image | Present; Figma export |
| Hero arrow / indicator | `HeroBannerArrow.imageset`, `HeroBannerIndicator.imageset` | HF/HeroBanner vectors | Present; arrow 16 × 16 pt, indicator 30 × 6 pt |
| Product placeholder / favorite | `ProductPlaceholder.imageset`, `ProductFavorite.imageset` | HF/Image and HF/ProductCard vectors | Present; placeholder 32 × 32 pt, favorite 20 × 20 pt |
| Top bar / tab icons | `TopBarMenu.imageset`, `TopBarBell.imageset`, `TabHome.imageset`, `TabCategory.imageset`, `TabSearch.imageset`, `TabCart.imageset`, `TabUser.imageset` | HF/App vectors | Present; 24 × 24 pt |
| Section chevron | `SectionChevron.imageset` | Home section action vector | Present; 16 × 16 pt |
| Search clear | `SearchClear.imageset` | A-06b `HF/Icon/circle-x`; Figma SVG | Present; 20 × 20 pt |
| Search sort | `SearchSort.imageset` | A-06b `HF/Icon/arrow-up-down`; Figma SVG | Present; 16 × 16 pt |
| Search filter | `SearchFilter.imageset` | A-06b `HF/Icon/sliders-horizontal`; Figma SVG | Present; 16 × 16 pt |

## Outstanding asset audit

- Home banner, placeholder imagery, and the observed navigation/component SVG icons have been imported. Individual product photography and remaining screen-specific art still need mapping/import.
- Logos, product imagery, banners, app icon candidates, and illustrations must be mapped per screen and downloaded from Figma before those screens are implemented.
- The Figma asset export for A-01 reports one source raster and no SVG layers. No generated or substituted brand imagery was added.
- Confirm Asset Catalog rendering mode, appearance variants, and scale declarations as each approved asset is imported.
