# DesignSystemForIOS

DesignSystemForIOS is an industrial-grade, reusable iOS design system foundation module.

DesignSystemForIOS 是一套面向工业研发的可复用 iOS 设计系统基础模块。

## Scope / 能力范围

1. Foundation tokens: color, spacing, dimension, radius, stroke, typography, shadow, motion.
2. Semantic tokens: stable UI intent mapping (`textPrimary`, `bgSurface`, `stateDanger`, etc.).
3. Primitives: `DSSurface`, `DSContainer`, `DSStateView`.
4. Theme and style policy: Light/Dark mode + Glass/Non-Glass runtime policy.
5. Base components: `DSButton`, `DSTag`, `DSFormTextField`, `DSListRow`, `DSTopBar`, `DSSheetScaffold`, `DSToastBanner`, `DSInlineLoadingView`.
6. Namespace entrypoint: `DesignSystem`.
7. Accessibility runtime policy: `DSAccessibilityPolicy`.
8. Visual regression image-hash baseline and governance gates.
9. Sample app target (`DesignSystemSampleApp`) compiled as part of governance build matrix.

1. Foundation 原子 token：颜色、间距、尺寸、圆角、描边、字体系、阴影、动效。
2. Semantic 语义 token：稳定 UI 意图映射（`textPrimary`、`bgSurface`、`stateDanger` 等）。
3. Primitive 原语：`DSSurface`、`DSContainer`、`DSStateView`。
4. 主题与视觉策略：支持 Light/Dark 与 Glass/Non-Glass 运行时策略。
5. 基础组件：`DSButton`、`DSTag`。
6. 命名空间入口：`DesignSystem`。
7. 可访问性运行时策略：`DSAccessibilityPolicy`。
8. 视觉回归图像哈希基线与治理门禁。
9. 示例应用 target（`DesignSystemSampleApp`）纳入构建矩阵门禁。

## Non-Goals / 非目标

1. No business domain coupling.
2. No network/storage/analytics side effects.
3. No app-specific assets, routes, or service contracts.

1. 不承载业务域模型。
2. 不引入网络/存储/埋点副作用。
3. 不包含项目专属资源、路由或服务契约。

## Installation / 安装

```swift
.package(url: "https://github.com/coffeecoproject/DesignSystemForIOS.git", from: "0.1.0")
```

## Quick Start / 快速使用

```swift
import DesignSystemForIOS
import SwiftUI

struct DemoView: View {
    var body: some View {
        DesignSystem.Primitive.Container {
            Text("Create Activity")
                .dsTextStyle(DesignSystem.Foundation.Typography.titleM)

            DesignSystem.Component.Button(
                title: "Continue",
                variant: .primary,
                size: .large
            ) {
                // action
            }

            DesignSystem.Component.Tag("Beta", variant: .info)
        }
        .dsRuntimeSurfaceCapabilityBridge()
        .dsVisualStylePolicy(
            .init(themeMode: .system, visualStyle: .glass)
        )
    }
}
```

## Industrial Guardrails / 工业护栏

1. Token-first: no raw visual literals in feature code.
2. Semantic-first: feature code uses semantic tokens, not primitive palette directly.
3. Layering discipline: Foundation -> Semantic -> Primitive -> Components.
4. All public API changes must update changelog and migration docs.
5. Governance gates are packaged in-repo and can be run with `./governance/run_all.sh`.

1. Token 优先：业务代码不直接写视觉字面量。
2. Semantic 优先：业务层优先使用语义 token，不直接耦合原子色板。
3. 分层约束：Foundation -> Semantic -> Primitive -> Components。
4. 任何公共 API 变更都必须同步 changelog 与迁移文档。
5. 门禁脚本随仓库维护，可通过 `./governance/run_all.sh` 执行。

## Documentation / 文档

1. [Docs Index / 文档索引](Docs/README.md)
2. [Architecture / 架构说明](Docs/Architecture.md)
3. [API Reference / API 参考](Docs/APIReference.md)
4. [Integration Guide / 接入指南](Docs/IntegrationGuide.md)
5. [Theming Guide / 主题扩展指南](Docs/ThemingGuide.md)
6. [Governance / 治理规范](Docs/Governance.md)
7. [Release Readiness / 发布检查](Docs/ReleaseReadiness.md)
8. [Accessibility Guide / 可访问性指南](Docs/AccessibilityGuide.md)
9. [Visual Regression Guide / 视觉回归指南](Docs/VisualRegressionGuide.md)
10. [Changelog / 更新日志](CHANGELOG.md)
11. [Contributing / 贡献指南](CONTRIBUTING.md)
12. [Security Policy / 安全策略](SECURITY.md)
13. [License / 授权协议](LICENSE)
