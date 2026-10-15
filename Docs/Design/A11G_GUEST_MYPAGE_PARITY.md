# A-11g Guest My Page Parity

- Figma node: `182:2279`, 390 × 844 pt, [A-11g guest My Page frame](https://www.figma.com/design/N3Ic9TfSnUBVMgAuayBVly?node-id=182-2279).
- Simulator screenshot: [`A11g-guest-my-page.png`](../Screenshots/A11g-guest-my-page.png).
- The logged-out state reuses the My tab bar and common product card, settings, support, notice and chevron assets.

## Implemented

- Login prompt panel with the Figma copy and a 48 pt login/signup action.
- Horizontally scrolling three-product recent-items row using the existing carousel card and placeholder art.
- Public customer center and notice rows.
- Login, settings, product, favorite and public-menu actions explain when their destination is not available.

## Visual comparison

- The body begins 8 pt below the top bar and separates login, recent products and public menu with 32 pt gaps.
- The login panel uses 24 pt inset, subtle surface, 12 pt radius and border. The horizontal cards retain 148 pt width and 132 pt image area.
- The Figma 390 × 844 pt frame and iPhone 18 Pro safe areas differ; the bottom navigation remains fixed while the body can scroll.

## Scope limits

- No authentication service or login screen exists in the current project. This view is implemented as a separate guest-state screen and its login action shows an informational notice; it is not selected as the app's default account state.
- Recent products use mock names and amounts. No order or account data is fetched.
