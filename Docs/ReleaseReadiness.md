# Release Readiness / 发布检查

## Checklist / 检查清单

1. `swift test` passes on release branch.
2. Public API diffs reviewed and semver-consistent.
3. `README`, `Docs`, and `CHANGELOG` updated.
4. No app-specific endpoints, tokens, or IDs in source/doc examples.
5. Security policy remains aligned with implementation boundaries.
6. `./governance/run_all.sh` passes, including structure and visual-regression baseline gates.
7. Local API signature baseline is reviewed (`check_api_breaking.sh`), and baseline refresh is documented when expected.
8. Visual snapshot baseline (`DSVisualSnapshotTests`) remains stable or has approved baseline refresh evidence.

1. 发布分支 `swift test` 全量通过。
2. 公共 API 变化完成审查并符合 semver。
3. `README`、`Docs`、`CHANGELOG` 已同步。
4. 源码与示例文档中无项目专属地址、token、ID。
5. 安全策略与实现边界保持一致。
6. `./governance/run_all.sh` 全量通过（含结构与视觉回归基线门禁）。
7. 本地 API 签名基线检查完成（`check_api_breaking.sh`），如有预期变更需记录基线更新。
8. 视觉快照基线（`DSVisualSnapshotTests`）保持稳定，或完成有记录的基线更新审批。
