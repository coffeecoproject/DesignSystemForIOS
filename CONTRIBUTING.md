# Contributing / 贡献指南

## Development Principles / 开发原则

1. Keep the package business-agnostic.
2. Preserve the layer contract: Foundation -> Semantic -> Primitive -> Components.
3. Prefer additive API evolution; avoid breaking changes in minor releases.

1. 保持模块与业务解耦。
2. 严格遵守分层契约：Foundation -> Semantic -> Primitive -> Components。
3. 优先做向后兼容的增量演进，避免在 minor 版本引入破坏性变更。

## Pull Request Checklist / PR 检查清单

1. `swift test` must pass.
2. New public API must include test coverage.
3. `README` and docs must be updated when behavior changes.
4. `CHANGELOG.md` must include user-facing impact.
5. No hardcoded project-specific endpoints, IDs, keys, or business constants.

1. `swift test` 必须通过。
2. 新增公共 API 必须有测试覆盖。
3. 行为变化必须同步 `README` 与文档。
4. `CHANGELOG.md` 必须记录用户可感知变更。
5. 禁止硬编码项目专属地址、ID、密钥和业务常量。
