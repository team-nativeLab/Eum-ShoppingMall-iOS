# Design Tokens

Source: high-fidelity Figma contexts for A-01 (`178:350`) and A-02 (`178:369`). These are observed values, not a complete published-variable export. The Figma variable-definition endpoint returned “nothing selected”; Code Connect/library enumeration is seat-gated.

## Color

| Token name | Observed value | Evidence |
|---|---|---|
| text-1 | `#111111` | Home component styles |
| text-2 | `#555555` | Home component styles |
| text-3 | `#707070` | Home component styles |
| bg | `#FFFFFF` | Home component styles |
| bg-subtle | `#FAFAFA` | Home component styles |
| surface | `#F5F5F5` | Home component styles |
| line | `#EBEBEB` | Home component styles |
| line-strong | `#D4D4D4` | Home component styles |
| line-control | `#949494` | TextField instance border |
| pressed-dark | `#333333` | Button pressed state |
| surface-2 | `#EBEBEB` | Button disabled state |
| text-disabled | `#B3B3B3` | Button disabled label |
| danger | `#C5221F` | Danger button default |
| inverse | `#FFFFFF` | Splash/Home component styles |
| inverse-2 | `rgba(255,255,255,0.72)` | Home component styles |
| splash overlay | `rgba(13,13,15,0.15 / 0.25 / 0.5)` | Splash gradient stops |
| image placeholder | `#F2F2F2 → #E8E8E8` | Home image placeholder |

No primary/secondary brand color or semantic success/warning/error palette was confirmed in the inspected contexts.

## Typography

Family: Noto Sans KR. Line height is reported by Figma context; letter spacing is in points.

| Style | Size / weight | Line height | Tracking |
|---|---:|---:|---:|
| Display L | 44 / 700 | 56 | -1.5 (Home context); Splash instance reports -0.66 |
| H2 | 22 / 700 | 30 | -2 |
| H3 | 18 / 700 | 26 | -1.5 |
| Body XL | 18 / 400 | 30 | 0 |
| Body M | 15 / 400 | 24 | -0.5 |
| Body S | 14 / 400 | 20 | -0.5 |
| Label L | 16 / 500 | 24 | -0.5 (Splash status instance reports -0.08) |
| Label M | 14 / 500 | 20 | -0.5 |
| Label XS | 11 / 500 | 14 | 0 |
| Caption Medium | 12 / 500 | 16 | 0 |
| Overline | 11 / 500 | 16 | 1.76 (node rendering resolves the design to 1.76 pt) |

## Layout values observed

- Page width: 390 pt.
- Splash top system bar: 44 pt; bottom indicator region: 34 pt with 134 × 5 pt indicator and 8 pt bottom inset.
- Splash content inset: 32 pt horizontal, 256 pt top, 40 pt bottom; brand gap 16 pt.
- Home top bar: 56 pt; content side inset: 20 pt; search bar 350 × 44 pt; hero instance 350 × 224 pt; home tab bar 91 pt.
- Radius tokens observed: 4, 6, 8, 12 pt; capsule 999 pt. HeroBanner description specifies 12 pt.
- Border, elevation/shadow, general spacing scale, and opacity values beyond listed surfaces/overlay have not been exhaustively extracted.
