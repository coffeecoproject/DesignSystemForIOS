# Integration Guide / 接入指南

## 1) Install / 安装

Add the package in your app:

```swift
.package(url: "https://github.com/coffeecoproject/DesignSystemForIOS.git", from: "0.1.0")
```

## 2) Use Namespace / 使用命名空间

```swift
import DesignSystemForIOS

let spacing = DesignSystem.Foundation.Spacing.s16
let accent = DesignSystem.Semantic.Color.accentPrimary
```

## 3) Build UI with Components / 使用组件构建 UI

```swift
DesignSystem.Component.Button(
    title: "Submit",
    variant: .primary,
    size: .large
) {
    submit()
}
```

## 4) Apply Theme and Visual Style / 设置主题与视觉体系

```swift
RootView()
    .dsRuntimeSurfaceCapabilityBridge()
    .dsVisualStylePolicy(
        .init(
            themeMode: .dark,
            visualStyle: .glass
        )
    )
```

You can also set them independently:

也可以分别设置：

```swift
RootView()
    .dsRuntimeSurfaceCapabilityBridge()
    .dsThemeMode(.light)
    .dsVisualStyle(.nonGlass)
```

When accessibility requests opaque surfaces (for example, Reduce Transparency or Increased Contrast), glass style is automatically downgraded to non-glass.

当系统无障碍要求不透明表面（例如“降低透明度”或“增强对比度”）时，glass 会自动降级为 non-glass。

You can inject explicit runtime capability in tests or previews:

你也可以在测试或预览中显式注入能力快照：

```swift
RootView()
    .dsSurfaceCapabilitySnapshot(
        .init(
            supportsGlassMaterial: false,
            accessibility: .init()
        )
    )
    .dsVisualStyle(.glass) // resolved result -> nonGlass
```

## 5) Migration Rule / 迁移规则

1. Replace hardcoded values with semantic tokens first.
2. Then swap feature-local controls with shared components.

1. 先把硬编码视觉值替换成语义 token。
2. 再将业务页面私有控件替换为共享组件。

## 6) Accessibility Baseline / 可访问性基线

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

## 7) Sample Skeleton / 示例骨架

Reference structure:
`Examples/SampleApp/`

可参考结构：
`Examples/SampleApp/`
