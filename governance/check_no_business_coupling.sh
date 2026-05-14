#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/Sources/DesignSystemForIOS"

forbidden_pattern='\b(Repository|UseCase|ViewModel|Session|Router|Coordinator|OSSUploadService|UserProfile|ImageCropService)\b'

matches="$(rg -n "$forbidden_pattern" "$SOURCE_DIR" || true)"
if [[ -n "$matches" ]]; then
  echo "[coupling] forbidden business/service coupling detected in shared module:"
  echo "$matches"
  exit 1
fi

echo "[coupling] no business/service coupling detected."
