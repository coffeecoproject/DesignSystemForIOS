#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  "Sources/DesignSystemForIOS/Components/Form/DSFormTextField.swift"
  "Sources/DesignSystemForIOS/Components/List/DSListRow.swift"
  "Sources/DesignSystemForIOS/Components/Navigation/DSTopBar.swift"
  "Sources/DesignSystemForIOS/Components/Feedback/DSSheetScaffold.swift"
  "Sources/DesignSystemForIOS/Components/Feedback/DSToastBanner.swift"
  "Sources/DesignSystemForIOS/Components/Feedback/DSInlineLoadingView.swift"
  "Sources/DesignSystemForIOS/Foundation/DSAccessibilityPolicy.swift"
  "Tests/DesignSystemForIOSTests/DSAccessibilityPolicyTests.swift"
  "Tests/DesignSystemForIOSTests/DSComponentStructureTests.swift"
  "Docs/VisualRegressionGuide.md"
  "Tests/VisualRegression/ComponentSnapshotMatrix.md"
  "governance/check_visual_regression_structure.sh"
  "governance/check_build_matrix.sh"
  "governance/check_security_hygiene.sh"
  "governance/check_release_readiness_gate.sh"
  "governance/check_api_breaking.sh"
  "governance/generate_api_baseline.sh"
  "governance/dependency_allowlist.txt"
  "governance/api_baseline/public_api_signatures.txt"
  "Examples/SampleApp/README.md"
  "Examples/SampleApp/Sources/SampleAppMain.swift"
  "Examples/SampleApp/Sources/SampleAppRootView.swift"
  "Examples/SampleApp/Sources/Screens/SampleHomeScreen.swift"
  "Examples/SampleApp/Sources/Screens/SampleFormScreen.swift"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "[structure-baseline] missing required file: $file"
    exit 1
  fi
done

echo "[structure-baseline] baseline structure is complete."
