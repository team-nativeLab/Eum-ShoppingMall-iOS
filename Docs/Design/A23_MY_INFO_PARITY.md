# A-23 My Info Verification Parity

- Figma frame: `350:3490` (390 × 844 pt)
- Simulator capture: [`A23-my-info.png`](../Screenshots/A23-my-info.png)
- Entry point: My Page → profile / 내 정보 관리
- Implementation: SwiftUI view and `AccountVerificationViewModel`.

## Implemented

- Navigation bar with back action and centered 내 정보 관리 title.
- Lock illustration on the subtle circular surface, confirmation heading, and explanatory copy.
- Disabled mock email field and secure password input.
- Fixed bottom confirmation button with top divider and safe-area handling.
- Reuses shared typography, colors, radii, `EUMButton`, and the existing back icon. The Figma lock SVG is stored in the Asset Catalog.

## Visual review

The iPhone 18 Pro simulator capture was reviewed against Figma. The content uses the 44 pt design status-bar inset, 56 pt top bar, 40 pt body inset, 64 pt lock tile, 48 pt fields, and 56 pt confirmation action. The screenshot reflects the system status bar and home indicator supplied by iOS.

## Scope and limitations

The displayed email is placeholder data. The confirmation action checks that a password was entered, then explains that account verification requires the future account service. It does not validate credentials or open the next profile screen.
