import SwiftUI

public enum DSDynamicTypePolicy: Sendable, Equatable {
    case system
    case fixed(DynamicTypeSize)
    case clamped(min: DynamicTypeSize, max: DynamicTypeSize)
}

public struct DSAccessibilityPolicy: Sendable, Equatable {
    public var dynamicTypePolicy: DSDynamicTypePolicy
    public var minimumHitTarget: CGFloat
    public var voiceOverHintsEnabled: Bool

    public init(
        dynamicTypePolicy: DSDynamicTypePolicy = .system,
        minimumHitTarget: CGFloat = DSDimensionTokens.d44,
        voiceOverHintsEnabled: Bool = true
    ) {
        self.dynamicTypePolicy = dynamicTypePolicy
        self.minimumHitTarget = max(DSDimensionTokens.d32, minimumHitTarget)
        self.voiceOverHintsEnabled = voiceOverHintsEnabled
    }

    public static let standard = DSAccessibilityPolicy()
}

private struct DSAccessibilityPolicyEnvironmentKey: EnvironmentKey {
    static let defaultValue: DSAccessibilityPolicy = .standard
}

public extension EnvironmentValues {
    var dsAccessibilityPolicy: DSAccessibilityPolicy {
        get { self[DSAccessibilityPolicyEnvironmentKey.self] }
        set { self[DSAccessibilityPolicyEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func dsAccessibilityPolicy(_ policy: DSAccessibilityPolicy) -> some View {
        modifier(DSAccessibilityPolicyModifier(policy: policy))
    }

    func dsDynamicTypePolicy(_ policy: DSDynamicTypePolicy) -> some View {
        modifier(DSDynamicTypePolicyModifier(policy: policy))
    }

    func dsMinimumHitTarget(_ value: CGFloat) -> some View {
        modifier(DSMinimumHitTargetPolicyModifier(minimumHitTarget: value))
    }

    func dsMinimumHitTargetFrame() -> some View {
        modifier(DSMinimumHitTargetFrameModifier())
    }
}

private struct DSAccessibilityPolicyModifier: ViewModifier {
    let policy: DSAccessibilityPolicy

    func body(content: Content) -> some View {
        let normalizedPolicy = DSAccessibilityPolicy(
            dynamicTypePolicy: policy.dynamicTypePolicy,
            minimumHitTarget: policy.minimumHitTarget,
            voiceOverHintsEnabled: policy.voiceOverHintsEnabled
        )
        return applyDynamicType(
            content: content.environment(\.dsAccessibilityPolicy, normalizedPolicy),
            policy: normalizedPolicy.dynamicTypePolicy
        )
    }
}

private struct DSDynamicTypePolicyModifier: ViewModifier {
    let policy: DSDynamicTypePolicy
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    func body(content: Content) -> some View {
        let updatedPolicy = DSAccessibilityPolicy(
            dynamicTypePolicy: policy,
            minimumHitTarget: accessibilityPolicy.minimumHitTarget,
            voiceOverHintsEnabled: accessibilityPolicy.voiceOverHintsEnabled
        )
        return applyDynamicType(
            content: content.environment(\.dsAccessibilityPolicy, updatedPolicy),
            policy: updatedPolicy.dynamicTypePolicy
        )
    }
}

private struct DSMinimumHitTargetPolicyModifier: ViewModifier {
    let minimumHitTarget: CGFloat
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    func body(content: Content) -> some View {
        let updatedPolicy = DSAccessibilityPolicy(
            dynamicTypePolicy: accessibilityPolicy.dynamicTypePolicy,
            minimumHitTarget: minimumHitTarget,
            voiceOverHintsEnabled: accessibilityPolicy.voiceOverHintsEnabled
        )
        return content.environment(\.dsAccessibilityPolicy, updatedPolicy)
    }
}

private struct DSMinimumHitTargetFrameModifier: ViewModifier {
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    func body(content: Content) -> some View {
        content.frame(
            minWidth: accessibilityPolicy.minimumHitTarget,
            minHeight: accessibilityPolicy.minimumHitTarget
        )
    }
}

private func applyDynamicType<V: View>(
    content: V,
    policy: DSDynamicTypePolicy
) -> some View {
    switch policy {
    case .system:
        return AnyView(content)
    case .fixed(let size):
        return AnyView(content.dynamicTypeSize(size))
    case .clamped(let min, let max):
        return AnyView(content.dynamicTypeSize(min ... max))
    }
}
