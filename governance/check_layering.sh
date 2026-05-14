#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="$ROOT_DIR/Sources/DesignSystemForIOS"
FOUNDATION_DIR="$BASE_DIR/Foundation"
SEMANTIC_DIR="$BASE_DIR/Semantic"
PRIMITIVE_DIR="$BASE_DIR/Primitives"
COMPONENT_DIR="$BASE_DIR/Components"

assert_no_match() {
  local layer="$1"
  local pattern="$2"
  local directory="$3"
  local output

  output="$(rg -n "$pattern" "$directory" || true)"
  if [[ -n "$output" ]]; then
    echo "[layering] $layer layer violated dependency direction:"
    echo "$output"
    exit 1
  fi
}

# Foundation must remain lowest-level and cannot depend on upper layers.
assert_no_match "foundation" 'DSSemantic|DSSurface|DSContainer|DSStateView|DSButton|DSTag|DSFormTextField|DSListRow|DSTopBar|DSSheetScaffold|DSToastBanner|DSInlineLoadingView' "$FOUNDATION_DIR"

# Semantic can depend on Foundation only.
assert_no_match "semantic" 'DSSurface|DSContainer|DSStateView|DSButton|DSTag|DSFormTextField|DSListRow|DSTopBar|DSSheetScaffold|DSToastBanner|DSInlineLoadingView' "$SEMANTIC_DIR"

# Primitive can depend on Semantic/Foundation but not Components.
assert_no_match "primitives" 'DSButton|DSTag|DSFormTextField|DSListRow|DSTopBar|DSSheetScaffold|DSToastBanner|DSInlineLoadingView' "$PRIMITIVE_DIR"

# Components are highest-level inside package, no reverse checks needed here.
if [[ ! -d "$COMPONENT_DIR" ]]; then
  echo "[layering] components directory missing: $COMPONENT_DIR"
  exit 1
fi

echo "[layering] layer dependency direction is valid."
