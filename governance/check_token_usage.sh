#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="$ROOT_DIR/Sources/DesignSystemForIOS"

PRIMITIVE_COMPONENT_DIRS=(
  "$BASE_DIR/Primitives"
  "$BASE_DIR/Components"
)

violations=0
for directory in "${PRIMITIVE_COMPONENT_DIRS[@]}"; do
  # Prevent raw color literals in upper layers.
  raw_color="$(rg -n 'Color\s*\(' "$directory" || true)"
  if [[ -n "$raw_color" ]]; then
    echo "[token-usage] raw Color(...) literal detected in $directory:"
    echo "$raw_color"
    violations=1
  fi

  # Prevent direct font literals in upper layers.
  raw_font="$(rg -n '\.system\s*\(size:' "$directory" || true)"
  if [[ -n "$raw_font" ]]; then
    echo "[token-usage] raw .system(size:) font literal detected in $directory:"
    echo "$raw_font"
    violations=1
  fi
done

if [[ "$violations" -ne 0 ]]; then
  exit 1
fi

echo "[token-usage] no raw visual literals found in primitive/component layers."
