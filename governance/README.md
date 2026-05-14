# Governance Gates

This folder contains release and PR gates for `DesignSystemForIOS`.

## Why Pack Governance with the Module

1. Ensures every consumer and maintainer runs the same checks.
2. Prevents process drift between local development and CI.
3. Keeps quality and architecture constraints versioned with code.

## Gates

1. `check_docs.sh`
   - required docs and policy files must exist.
2. `check_no_business_coupling.sh`
   - shared module source must not depend on business/service concepts.
3. `check_layering.sh`
   - enforces Foundation -> Semantic -> Primitive -> Components dependency direction.
4. `check_token_usage.sh`
   - avoids raw visual literals in upper layers.
5. `check_structure_baseline.sh`
   - validates industrial scaffold completeness (components/accessibility/visual baseline/sample app).
6. `check_visual_regression_structure.sh`
   - validates snapshot scenario matrix structure.
7. `check_security_hygiene.sh`
   - scans secrets, private endpoints, and dependency governance constraints.
8. `check_build_matrix.sh`
   - enforces macOS + iOS simulator + iOS device compile compatibility and sample app buildability.
9. `generate_api_baseline.sh`
   - regenerates local public API signature baseline.
10. `check_api_breaking.sh`
   - API breaking gate via SwiftPM baseline ref or local signature baseline.
11. `check_release_readiness_gate.sh`
   - validates semver, changelog contract, and bilingual release docs baseline.
12. `run_all.sh`
   - orchestration entrypoint for local and CI checks.
