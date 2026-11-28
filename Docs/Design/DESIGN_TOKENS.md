# Design Tokens

Source: high-fidelity Figma contexts for A-01 (`178:350`), A-02 (`178:369`), A-17 (`351:3440`), A-18 (`351:3570`), and A-19 (`353:3555`). These were first recorded from observed component styles. Since #284, the values listed with a Figma variable name come from `get_variable_defs` (A-01 `178:369`, A-13e `558:5680`) and match pixel samples of the Figma render.

Figma variables also define screen background `hf/bg` = `#FAFAFA` and card/field `hf/surface` = `#FFFFFF`. iOS currently uses `bg` = `#FFFFFF` for both roles. Splitting the two roles needs a per-screen check, so it is tracked separately in #284.

Original note: these are observed values, not a complete published-variable export. The Figma variable-definition endpoint returned “nothing selected”; Code Connect/library enumeration is seat-gated.

## Color

| Token name | Observed value | Evidence |
|---|---|---|
| text-1 | `#171717` | Figma variable `hf/text-1` (#284) |
| text-2 | `#4A4A4A` | Figma variable `hf/text-2` (#284) |
| text-3 | `#666666` | Figma variable `hf/text-3` (#284) |
| bg | `#FFFFFF` | Home component styles |
| bg-subtle | `#FAFAFA` | Home component styles |
| surface | `#F5F5F5` | Home component styles |
| surface-2 | `#F2F2F2` | Figma variable `hf/surface-2` (#284) |
| line | `#E5E5E5` | Figma variable `hf/line` (#284) |
| line-strong | `#8C8C8C` | Figma variable `hf/line-strong` (#284) |
| line-control | `#777777` | Figma variable `hf/line-control` (#284) |
| pressed-dark | `#333333` | Button pressed state |
| text-disabled | `#707070` | Figma variable `hf/text-disabled` (#284) |
| danger | `#C5221F` | A-05h price inquiry notice / danger button |
| danger background | `#FFE9E9` | Price-hidden notice (`179:1109`, `180:1258`) |
| inverse | `#FFFFFF` | Splash/Home component styles |
| inverse-2 | `rgba(255,255,255,0.72)` | Home component styles |
| splash overlay | `rgba(13,13,15,0.15 / 0.25 / 0.5)` | Splash gradient stops |
| image placeholder top | `#F2F2F2` | `HF/Image` gradient (`351:3440`, `351:3570`) |
| image placeholder bottom | `#E8E8E8` | `HF/Image` gradient (`351:3440`, `351:3570`) |
| image placeholder secondary top | `#ECECEC` | `HF/Image` tone ph-2 (`353:3555`) |
| image placeholder secondary bottom | `#DCDCDC` | `HF/Image` tone ph-2 (`353:3555`) |

No primary/secondary brand color or full semantic palette was confirmed; A-05h provides the danger foreground/background pair above.

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
