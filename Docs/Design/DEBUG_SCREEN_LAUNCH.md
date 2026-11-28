# Debug screen launch (#289)

Debug builds accept `-debug-screen <Figma code>` and open that screen right after Home loads. Release builds do not include this code (`#if DEBUG`).

```sh
xcrun simctl launch booted com.teamnativelab.eumshoppingmall -debug-screen A-22
xcrun simctl io booted screenshot A-22.png
```

Supported codes are listed in `DebugScreenLaunch.supportedCodes` (`Projects/App/Sources/Features/Home/DebugScreenLaunch.swift`). Duplicate Figma numbers use a suffix: `A-43-company`, `A-54-events`. State variants (errors, empty states, sheets, dialogs) still need their UI tests or flags.

## Comparison workflow used for the 2026-11-28 sweep

1. Capture every supported code with the command above (3 s wait after launch, status bar fixed to 9:41).
2. Download each Figma frame at 1× with the Figma MCP `get_screenshot`.
3. Compare the top 390 × 844 pt of the frame against the capture scaled to 1×, side by side.
