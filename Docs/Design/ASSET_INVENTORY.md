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
| Favorite selected heart | `ProductFavoriteSelected.imageset/favorite-selected.svg` | A-20 `HF/ProductCard` selected heart; Figma SVG | Present; filled 20 × 20 pt vector |
| Recently viewed remove | `RecentlyViewedRemove.imageset/remove.svg` | A-21 card remove action; Figma SVG | Present; black stroke X, 20 × 20 pt vector |
| Coupon coins / ticket | `CouponCoins.imageset/coins.svg`, `CouponTicket.imageset/ticket.svg` | A-22 points balance and coupon scope icons; Figma SVGs | Present; 20 × 20 pt vectors |
| Profile edit controls | `ProfileEditCheck.imageset/check.svg`, `ProfileEditPassword.imageset/password.svg`, `ProfileEditChevron.imageset/chevron.svg` | A-23e checkbox, password row, and disclosure; Figma SVGs | Present; 14/20 pt vectors |
| Address editor validation/dropdown | `AddressEditorAlert.imageset/alert.svg`, `AddressEditorChevronDown.imageset/chevron-down.svg` | A-24e phone error and delivery-request disclosure; Figma SVGs | Present; 14/20 pt vectors |
| Top bar / tab icons | `TopBarMenu.imageset`, `TopBarBell.imageset`, `TabHome.imageset`, `TabCategory.imageset`, `TabSearch.imageset`, `TabCart.imageset`, `TabUser.imageset` | HF/App vectors | Present; 24 × 24 pt |
| Section chevron | `SectionChevron.imageset` | Home section action vector | Present; 16 × 16 pt |
| Search clear | `SearchClear.imageset` | A-06b `HF/Icon/circle-x`; Figma SVG | Present; 20 × 20 pt |
| Search sort | `SearchSort.imageset` | A-06b `HF/Icon/arrow-up-down`; Figma SVG | Present; 16 × 16 pt |
| Search filter | `SearchFilter.imageset` | A-06b `HF/Icon/sliders-horizontal`; Figma SVG | Present; 16 × 16 pt |
| Search empty-state icon | `SearchEmpty.imageset` | A-06z `HF/Icon/search-x`; Figma SVG | Present; 28 × 28 pt |
| Cart controls | `ProductPlaceholder.imageset`, `ProductOptionMinus.imageset`, `ProductOptionPlus.imageset`, `ProductOptionClose.imageset`, `DesignSearch.imageset`, and `Tab*.imageset` | Existing Figma vectors reused by A-07 | Present; placeholder displayed at 32 pt inside an 80 pt tile; no new asset required |
| Cart quote state | Reuses cart controls above plus `ProductPlaceholder.imageset` | A-07h mixed priced/quote cart | Present; no new image assets required |
| Zero-order cart state | Reuses cart quote, placeholder, search, and tab vectors | A-07h2 with two inquiry-only products | Present; no new image assets required |
| Checkout address controls | `ProductListBack.imageset`, `ProductOptionChevron.imageset` | Existing Figma back and disclosure vectors reused by A-08 | Present; progress indicators and section surfaces use native shapes |
| My Page vectors | `MyPageProfile.imageset`, `MyPageOrder.imageset`, `MyPageFavorites.imageset`, `MyPageRecent.imageset`, `MyPageCoupons.imageset`, `MyPageInformation.imageset`, `MyPageAddress.imageset`, `MyPageReturns.imageset`, `MyPageQuoteInquiries.imageset`, `MyPageContactInquiries.imageset`, `MyPageSupport.imageset`, `MyPageNotices.imageset`, `MyPageChevron.imageset`, `MyPageSettings.imageset` | Figma A-11 vectors; SVG in Asset Catalog | Present; profile and menu/shortcut icons 20–36 pt, details in `A11_MYPAGE_PARITY.md` |
| Drawer logout icon | `DrawerLogout.imageset` | Figma A-12 logout vector | Present; SVG in Asset Catalog, 20 × 20 pt |
| Login info icon | `LoginInfo.imageset` | Figma A-13 inline notice vector | Present; SVG in Asset Catalog, 16 × 16 pt |
| Quote inquiry paperclip | `QuotePaperclip.imageset` | Figma A-15 file attachment icon | Present; SVG in Asset Catalog, rendered at 20 × 20 pt |
| Quote history document | `QuoteHistoryFile.imageset` | Figma A-25 file-text icon | Present; SVG in Asset Catalog, rendered at 16 × 16 pt |
| Withdrawal benefit icons | `CouponTicket.imageset`, `CouponCoins.imageset` | Figma A-26 coupon and points benefit summary | Existing A-22 assets reused; no duplicate exports added |
| Withdrawal password visibility | `WithdrawalPasswordVisibility.imageset` | Figma A-26r password field trailing icon | Present; Figma SVG eye-off vector, 20 × 20 pt |
| Withdrawal confirmation warning | `WithdrawalAlert.imageset` | Figma A-26c red alert-circle icon | Present; Figma SVG, 20 × 20 pt; impact rows reuse `CouponTicket` and `CouponCoins` |
| Withdrawal completion check | `WithdrawalComplete.imageset` | Figma A-26d white check on dark circle | Present; Figma SVG check vector, 32 × 32 pt; existing close/info assets reused |

## Outstanding asset audit

- Home banner, placeholder imagery, and the observed navigation/component SVG icons have been imported. Individual product photography and remaining screen-specific art still need mapping/import.
- Logos, product imagery, banners, app icon candidates, and illustrations must be mapped per screen and downloaded from Figma before those screens are implemented.
- The Figma asset export for A-01 reports one source raster and no SVG layers. No generated or substituted brand imagery was added.
- Confirm Asset Catalog rendering mode, appearance variants, and scale declarations as each approved asset is imported.
