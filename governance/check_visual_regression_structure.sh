#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  "Docs/VisualRegressionGuide.md"
  "Tests/VisualRegression/README.md"
  "Tests/VisualRegression/ComponentSnapshotMatrix.md"
  "Tests/VisualRegression/Baselines/hash_manifest.json"
  "Tests/DesignSystemForIOSTests/DSVisualSnapshotTests.swift"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "[visual-regression] missing required file: $file"
    exit 1
  fi
done

matrix_file="Tests/VisualRegression/ComponentSnapshotMatrix.md"
baseline_file="Tests/VisualRegression/Baselines/hash_manifest.json"
required_components=(
  "DSSurface"
  "DSStateView"
  "DSButton"
  "DSTag"
  "DSFormTextField"
  "DSListRow"
  "DSTopBar"
  "DSSheetScaffold"
  "DSToastBanner"
  "DSInlineLoadingView"
)

for component in "${required_components[@]}"; do
  if ! rg -q "$component" "$matrix_file"; then
    echo "[visual-regression] component missing in snapshot matrix: $component"
    exit 1
  fi
done

for mode in "light" "dark" "glass" "non-glass"; do
  if ! rg -qi "$mode" "$matrix_file"; then
    echo "[visual-regression] mode missing in snapshot matrix: $mode"
    exit 1
  fi
done

required_snapshot_ids=(
  "surface.light.non_glass"
  "surface.dark.glass"
  "button.light.primary"
  "button.dark.secondary.glass"
  "list_row.light.non_glass"
  "toast.dark.glass"
)

for snapshot_id in "${required_snapshot_ids[@]}"; do
  if ! rg -q "\"$snapshot_id\"" "$baseline_file"; then
    echo "[visual-regression] snapshot id missing in baseline manifest: $snapshot_id"
    exit 1
  fi
done

echo "[visual-regression] snapshot structure baseline is complete."
