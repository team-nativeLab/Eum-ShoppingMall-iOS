#!/bin/bash
# Captures simulator screenshots for the given Figma codes using the debug-only launcher.
# Example: Scripts/parity/capture.sh build/EumShoppingMall.app com.teamnativelab.eumshoppingmall out A-22 A-25
# Extra launch arguments: EXTRA_ARGS="-ui-test-empty-account" Scripts/parity/capture.sh ...
# Usage: capture.sh <app path> <bundle id> <out dir> <codes...>
set -u
app="$1"; bid="$2"; out="$3"; shift 3
mkdir -p "$out"
xcrun simctl install booted "$app"
xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3 >/dev/null 2>&1 || true
for code in "$@"; do
  xcrun simctl terminate booted "$bid" >/dev/null 2>&1 || true
  xcrun simctl launch booted "$bid" ${EXTRA_ARGS:-} -debug-screen "$code" >/dev/null
  sleep 5
  xcrun simctl io booted screenshot "$out/$code.png" >/dev/null 2>&1 && echo "ok $code" || echo "fail $code"
done
