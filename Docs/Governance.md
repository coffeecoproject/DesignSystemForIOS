# Governance / 治理规范

## Governance Packaging Decision / 门禁打包决策

Governance gates are packaged with this module repository (`governance/` + CI workflow), but they are not linked into runtime targets.

治理门禁随模块仓库一并维护（`governance/` + CI workflow），但不进入运行时 target。

## API Governance / API 治理

1. Public API changes require semver impact review.
2. Breaking changes require a migration section and major version bump.
3. Deprecated API should remain for at least one minor line when feasible.

1. 公共 API 变更必须评估 semver 影响。
2. 破坏性变更必须提供迁移说明并提升 major 版本。
3. 可行情况下，废弃 API 至少保留一个 minor 周期。

## Quality Gates / 质量闸门

1. Unit tests pass (`swift test`).
2. No business coupling in shared module.
3. Docs and changelog are synchronized.
4. No hardcoded secrets or private endpoints.
5. Layer dependency direction remains valid.
6. Primitive/component layers avoid raw visual literals.
7. Structure baseline for industrial module extraction remains complete.
8. Visual regression scenario matrix remains complete.
9. Security/privacy hygiene and dependency governance remain clean.
10. Cross-platform build matrix remains green.

1. 单测通过（`swift test`）。
2. 共享模块不得引入业务耦合。
3. 文档和变更日志同步更新。
4. 禁止硬编码密钥或私有地址。
5. 分层依赖方向必须保持正确。
6. Primitive/Component 层禁止原始视觉字面量。
7. 工业化抽离所需结构基线必须保持完整。
8. 视觉回归场景矩阵必须保持完整。
9. 安全/隐私与依赖治理必须持续通过。
10. 跨平台构建矩阵必须持续通过。

## Gate Commands / 门禁命令

1. `./governance/run_all.sh`
2. `./governance/check_docs.sh`
3. `./governance/check_layering.sh`
4. `./governance/check_no_business_coupling.sh`
5. `./governance/check_token_usage.sh`
6. `./governance/check_structure_baseline.sh`
7. `./governance/check_visual_regression_structure.sh`
8. `./governance/check_api_breaking.sh`
9. `./governance/check_security_hygiene.sh`
10. `./governance/check_build_matrix.sh`
11. `./governance/check_release_readiness_gate.sh`
12. `./governance/generate_api_baseline.sh`
