#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[governance] running documentation gate..."
./governance/check_docs.sh

echo "[governance] running structure baseline gate..."
./governance/check_structure_baseline.sh

echo "[governance] running architecture layering gate..."
./governance/check_layering.sh

echo "[governance] running anti-coupling gate..."
./governance/check_no_business_coupling.sh

echo "[governance] running token usage gate..."
./governance/check_token_usage.sh

echo "[governance] running visual regression structure gate..."
./governance/check_visual_regression_structure.sh

echo "[governance] running security/privacy hygiene gate..."
./governance/check_security_hygiene.sh

echo "[governance] running build matrix gate..."
./governance/check_build_matrix.sh

echo "[governance] running test gate..."
swift test

echo "[governance] running API compatibility gate (optional)..."
./governance/check_api_breaking.sh

echo "[governance] running release readiness gate..."
./governance/check_release_readiness_gate.sh

echo "[governance] all gates passed."
