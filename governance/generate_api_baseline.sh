#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/Sources/DesignSystemForIOS"
OUTPUT_DIR="$ROOT_DIR/governance/api_baseline"
OUTPUT_FILE="$OUTPUT_DIR/public_api_signatures.txt"

mkdir -p "$OUTPUT_DIR"

rg --no-heading --line-number \
  '^\s*public\s+(enum|struct|class|protocol|typealias|extension|init|func|var|let)\b' \
  "$SOURCE_DIR" \
  | sed -E "s#${ROOT_DIR}/##" \
  | sed -E 's#:[0-9]+:#:#' \
  | sed -E 's/[[:space:]]+/ /g' \
  | sort -u > "$OUTPUT_FILE"

echo "[api-baseline] generated: governance/api_baseline/public_api_signatures.txt"
