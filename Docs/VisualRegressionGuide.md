# Visual Regression Guide / 视觉回归指南

## Goal / 目标

Keep component rendering stable across:
1. Light and Dark color schemes
2. Glass and Non-Glass visual styles
3. Standard and accessibility-oriented runtime capabilities

保证组件在以下维度稳定：
1. Light / Dark
2. Glass / Non-Glass
3. 标准与无障碍降级运行时能力

## Scope Baseline / 基线范围

Snapshot baseline scope is tracked in:
`Tests/VisualRegression/ComponentSnapshotMatrix.md`
`Tests/VisualRegression/Baselines/hash_manifest.json`

快照基线范围记录在：
`Tests/VisualRegression/ComponentSnapshotMatrix.md`
`Tests/VisualRegression/Baselines/hash_manifest.json`

## Execution Strategy / 执行策略

1. Keep scenario matrix complete first (structure gate).
2. Then connect project-specific snapshot toolchain (Point-Free SnapshotTesting or XCUITest screenshot flow).
3. Run snapshot checks in CI for changed components only when possible.

1. 先保证场景矩阵完整（结构门禁）。
2. 再按项目实际接入快照工具链（如 SnapshotTesting 或 XCUITest 截图流）。
3. CI 中尽量只对变更组件执行快照比对。

## Current Stage / 当前阶段

This repository currently ships the **snapshot structure baseline** and governance gate, without forcing a specific screenshot framework.

当前仓库先提供**快照结构基线**和治理门禁，不强绑某个截图框架。

Image-level snapshot hashing is enforced by test:
`DSVisualSnapshotTests`

升级视觉基线时执行：
`DS_RECORD_SNAPSHOTS=1 swift test --filter DSVisualSnapshotTests/testVisualSnapshots`
