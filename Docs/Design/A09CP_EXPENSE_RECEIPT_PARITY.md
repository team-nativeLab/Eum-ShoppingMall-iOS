# A-09c-p Expense Evidence Parity

## Reference

- Figma: `566:26719` (390 × 1375 pt)
- State: bank transfer selected, cash receipt selected, expense evidence selected, business registration identifier `000-00-00000`.

## Implemented

- Kept the checkout's existing payment and receipt selection flow.
- Added explicit initial-state configuration so this Figma variant can render with bank transfer and expense evidence selected while the normal checkout retains its existing defaults.
- Expense evidence identifiers are limited to 10 digits and formatted as `000-00-00000`; the income deduction mode retains its phone-number formatting.
- The expense evidence panel omits the income deduction issuance helper, matching the reference.

## Validation

- SwiftLint strict: 0 violations.
- Tuist generation: passed.
- iPhone 17 Pro simulator build and app launch: passed.
- Simulator tests: 99 passed, 0 failed.
- `git diff --check`: passed.

## Visual capture

Figma node `566:26719` was inspected through design context. The Xcode UI snapshot tool cannot load `SimulatorKit.framework` in this environment. The app launched on the simulator, but the checkout route was not captured; target-screen visual comparison remains unverified.
