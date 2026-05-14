#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[build-matrix] building macOS library target..."
swift build --target DesignSystemForIOS

echo "[build-matrix] building sample app target..."
swift build --target DesignSystemSampleApp

echo "[build-matrix] building iOS simulator library target..."
xcodebuild \
  -scheme DesignSystemForIOS \
  -destination "generic/platform=iOS Simulator" \
  -skipPackagePluginValidation \
  -skipMacroValidation \
  build >/dev/null

echo "[build-matrix] building iOS device library target..."
xcodebuild \
  -scheme DesignSystemForIOS \
  -destination "generic/platform=iOS" \
  -skipPackagePluginValidation \
  -skipMacroValidation \
  build >/dev/null

echo "[build-matrix] platform build matrix passed."
