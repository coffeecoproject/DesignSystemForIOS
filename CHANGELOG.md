# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

1. Runtime surface capability contract (`DSStyleCapabilitySnapshot`, `DSAccessibilitySnapshot`) and policy resolver (`DSVisualStyleResolver`).
2. Root bridge API `dsRuntimeSurfaceCapabilityBridge()` for accessibility-aware style routing.
3. Explicit capability injection API `dsSurfaceCapabilitySnapshot(_:)` for tests/previews.
4. Industrial component skeleton coverage: `DSFormTextField`, `DSListRow`, `DSTopBar`, `DSSheetScaffold`, `DSToastBanner`, `DSInlineLoadingView`.
5. Accessibility policy baseline: `DSAccessibilityPolicy`, `DSDynamicTypePolicy`, `dsAccessibilityPolicy(_:)`, and minimum hit-target support.
6. Visual regression structure baseline (`Tests/VisualRegression/*`, `Docs/VisualRegressionGuide.md`) and governance gate.
7. Sample app skeleton scaffold under `Examples/SampleApp`.
8. Local public API signature baseline workflow (`generate_api_baseline.sh` + `governance/api_baseline/public_api_signatures.txt`).
9. Image-hash visual snapshot regression test (`DSVisualSnapshotTests`) and baseline manifest.
10. `DesignSystemSampleApp` executable target and main entrypoint for compile-verified onboarding example.
11. Security/privacy hygiene gate and dependency allowlist governance.
12. Cross-platform build matrix gate (macOS, iOS simulator, iOS device).
13. Release-readiness gate script for semver/changelog/bilingual contract validation.

### Changed

1. `DSSurface`, `DSButton`, and `DSTag` now resolve requested style through capability-aware policy routing before rendering glass effects.
2. Tests expanded for capability fallback and accessibility-driven downgrade behaviors.
3. Governance runner now includes structure and visual-regression baseline checks.
4. `check_api_breaking.sh` now supports local signature baseline checks when `DS_API_BASELINE_REF` is not provided.
5. Integration/theming/API docs updated with runtime policy guidance.
6. CI workflow now runs full governance pipeline as single source of truth.

## [0.1.0] - 2026-05-15

### Added

1. Independent SPM package skeleton for `DesignSystemForIOS`.
2. Foundation token layer (`DSCoreColorTokens`, spacing, dimension, radius, stroke, typography, shadow, motion).
3. Semantic token layer (`DSSemanticColorTokens`, `DSSemanticSpacingTokens`).
4. Primitive layer (`DSSurface`, `DSContainer`, `DSStateView`).
5. Base components (`DSButton`, `DSTag`) with style resolver contract.
6. Namespace entrypoint (`DesignSystem`) for stable API discoverability.
7. Unit tests for token safety, semantic mapping, style resolution, and version contract.
8. Bilingual documentation set and governance baseline.
9. Added theme/style runtime policy: Light/Dark mode and Glass/Non-Glass visual system.
10. Added governance-aligned render policy coverage tests for surface and button style specs.
