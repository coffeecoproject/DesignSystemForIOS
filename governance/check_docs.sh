#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  "README.md"
  "CHANGELOG.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "LICENSE"
  "Docs/README.md"
  "Docs/Architecture.md"
  "Docs/APIReference.md"
  "Docs/IntegrationGuide.md"
  "Docs/ThemingGuide.md"
  "Docs/AccessibilityGuide.md"
  "Docs/VisualRegressionGuide.md"
  "Docs/Governance.md"
  "Docs/ReleaseReadiness.md"
)

missing=0
for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "[docs] missing required file: $path"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  exit 1
fi

echo "[docs] required documentation set is complete."
