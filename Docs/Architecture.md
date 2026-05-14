# Architecture / 架构说明

## Layer Model / 分层模型

1. Foundation
   - raw primitives and token contracts
   - no business semantics
2. Semantic
   - maps design intent to foundation tokens
   - stable interface for product code
3. Primitive
   - neutral view shells and layout surfaces
4. Components
   - reusable controls based on primitives and semantic tokens
5. Governance/Examples (non-runtime)
   - governance scripts, visual regression matrix, sample app skeleton

1. Foundation
   - 原子能力与 token 契约
   - 不承载业务语义
2. Semantic
   - 将设计意图映射到 foundation token
   - 作为业务代码的稳定接口
3. Primitive
   - 中立的视图壳层与布局表面
4. Components
   - 基于 primitive 与 semantic 的可复用控件
5. Governance/Examples（不进入运行时）
   - 治理脚本、视觉回归矩阵、示例应用骨架

## Dependency Rule / 依赖规则

Allowed:
- Components -> Primitive -> Semantic -> Foundation

Forbidden:
- Foundation depending on upper layers
- Cross-layer back references
- Any layer depending on app-specific services

允许：
- Components -> Primitive -> Semantic -> Foundation

禁止：
- Foundation 反向依赖上层
- 分层逆向引用
- 任意层依赖项目专属服务
