# Accessibility Guide / 可访问性指南

## Baseline Policy / 基线策略

Use `DSAccessibilityPolicy` at app root:

在应用根节点设置 `DSAccessibilityPolicy`：

```swift
RootView()
    .dsAccessibilityPolicy(
        .init(
            dynamicTypePolicy: .clamped(min: .small, max: .accessibility3),
            minimumHitTarget: 44,
            voiceOverHintsEnabled: true
        )
    )
```

## Policy Dimensions / 策略维度

1. Dynamic Type policy (`system` / `fixed` / `clamped`)
2. Minimum hit target
3. VoiceOver hint strategy switch

1. 动态字体策略（`system` / `fixed` / `clamped`）
2. 最小可点击区域
3. VoiceOver 提示开关策略

## Industrial Rule / 工业规范

1. New interactive controls should respect `minimumHitTarget`.
2. Controls with icon-only affordance should always provide `accessibilityLabel`.
3. Snapshot matrix must include accessibility fallback scenarios.

1. 新增交互控件应遵守 `minimumHitTarget`。
2. 纯图标交互控件必须提供 `accessibilityLabel`。
3. 快照矩阵必须包含无障碍降级场景。
