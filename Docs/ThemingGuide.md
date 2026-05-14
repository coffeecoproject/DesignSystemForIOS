# Theming Guide / 主题扩展指南

## Principle / 原则

Keep product theme overrides in semantic layer mappings, not in component internals.

主题差异优先在 semantic 映射层处理，不在组件内部写分支。

## Recommended Approach / 推荐方式

1. Add new core palette in `DSCoreColorTokens`.
2. Map semantic intents in `DSSemanticColorTokens`.
3. Reuse existing components without changing behavior contracts.
4. Keep runtime style routing in policy layer (`DSVisualStylePolicy` + capability bridge), not in business views.

1. 在 `DSCoreColorTokens` 增加新色板。
2. 在 `DSSemanticColorTokens` 完成语义映射。
3. 不改组件行为契约，直接复用组件。
4. 运行时风格路由放在策略层（`DSVisualStylePolicy` + capability bridge），不要散落在业务页面。

## Runtime Policy / 运行时策略

Use `dsRuntimeSurfaceCapabilityBridge()` at app root to capture accessibility signals.  
If the app requests `.glass` but runtime capability is insufficient, or accessibility prefers opaque surfaces, the module auto-resolves to `.nonGlass`.

在应用根节点使用 `dsRuntimeSurfaceCapabilityBridge()` 采集无障碍信号。  
当应用请求 `.glass` 但运行时能力不足，或无障碍偏好不透明时，模块会自动解析为 `.nonGlass`。

## Anti-Patterns / 反模式

1. Injecting app-specific business colors in reusable components.
2. Duplicating component variants for each app.

1. 在通用组件里写项目专属业务颜色。
2. 每个应用复制一套组件变体。
