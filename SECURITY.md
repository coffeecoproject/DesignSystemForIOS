# Security Policy / 安全策略

## Supported Versions / 维护版本

Security fixes are applied to the latest minor line.

安全修复默认覆盖最新 minor 版本线。

## Reporting a Vulnerability / 漏洞上报

Please report vulnerabilities to maintainers through a private channel.

请通过私密渠道向维护者上报漏洞，避免公开披露未修复细节。

## Security Guarantees / 安全保证边界

This package guarantees:

1. No built-in network/storage/analytics side effects.
2. No built-in credential/session/token handling.
3. No runtime dependency on external service endpoints.

本包保证：

1. 不内置网络/存储/埋点副作用。
2. 不内置凭证/会话/token 处理逻辑。
3. 运行时不依赖外部服务地址。

Host apps remain responsible for:

1. Data classification and telemetry controls.
2. Access control and secure transport in downstream systems.
3. Compliance and privacy retention policies.

宿主应用仍需负责：

1. 数据分级和埋点策略治理。
2. 下游系统的访问控制与传输安全。
3. 合规与隐私留存策略。
