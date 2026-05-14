#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

version="$(rg -n 'public static let version = ' Sources/DesignSystemForIOS/DesignSystem.swift | sed -E 's/.*"([^"]+)".*/\1/' | head -n1)"
if [[ -z "$version" ]]; then
  echo "[release] failed to read DesignSystem version."
  exit 1
fi

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "[release] invalid semantic version in DesignSystem.version: $version"
  exit 1
fi

if ! rg -q '^## \[Unreleased\]' CHANGELOG.md; then
  echo "[release] CHANGELOG missing [Unreleased] section."
  exit 1
fi

if ! rg -q "^## \\[$version\\]" CHANGELOG.md; then
  echo "[release] CHANGELOG missing released section for DesignSystem.version: $version"
  exit 1
fi

bilingual_docs=(
  "README.md"
  "Docs/README.md"
  "Docs/Architecture.md"
  "Docs/APIReference.md"
  "Docs/IntegrationGuide.md"
  "Docs/ThemingGuide.md"
  "Docs/AccessibilityGuide.md"
  "Docs/VisualRegressionGuide.md"
  "Docs/Governance.md"
  "Docs/ReleaseReadiness.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
)

for file in "${bilingual_docs[@]}"; do
  if ! rg -q '[\p{Han}]' "$file"; then
    echo "[release] bilingual requirement not met: $file"
    exit 1
  fi
done

echo "[release] release readiness gate passed."
