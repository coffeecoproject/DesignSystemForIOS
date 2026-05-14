#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

baseline_ref="${DS_API_BASELINE_REF:-}"

if [[ -n "$baseline_ref" ]]; then
  if ! swift package --help | grep -q "diagnose-api-breaking-changes"; then
    echo "[api-break] skipped: current SwiftPM does not expose diagnose-api-breaking-changes."
    exit 0
  fi

  echo "[api-break] checking public API against baseline: $baseline_ref"
  swift package diagnose-api-breaking-changes "$baseline_ref"
  echo "[api-break] no API breaking changes detected."
  exit 0
fi

BASELINE_FILE="$ROOT_DIR/governance/api_baseline/public_api_signatures.txt"
if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "[api-break] missing local baseline file: governance/api_baseline/public_api_signatures.txt"
  echo "[api-break] run ./governance/generate_api_baseline.sh first."
  exit 1
fi

TMP_CURRENT="$(mktemp)"
trap 'rm -f "$TMP_CURRENT"' EXIT

rg --no-heading --line-number \
  '^\s*public\s+(enum|struct|class|protocol|typealias|extension|init|func|var|let)\b' \
  "$ROOT_DIR/Sources/DesignSystemForIOS" \
  | sed -E "s#${ROOT_DIR}/##" \
  | sed -E 's#:[0-9]+:#:#' \
  | sed -E 's/[[:space:]]+/ /g' \
  | sort -u > "$TMP_CURRENT"

if ! diff -u "$BASELINE_FILE" "$TMP_CURRENT"; then
  echo "[api-break] public API signature drift detected."
  echo "[api-break] if this change is expected, run ./governance/generate_api_baseline.sh and update CHANGELOG/migration notes."
  exit 1
fi

echo "[api-break] local API baseline check passed."
