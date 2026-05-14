import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum DSThemeMode: Sendable, Equatable {
    case system
    case light
    case dark
}

public enum DSVisualStyle: Sendable, Equatable {
    case nonGlass
    case glass
}

public struct DSAccessibilitySnapshot: Sendable, Equatable {
    public let reduceTransparencyEnabled: Bool
    public let increasedContrastEnabled: Bool

    public init(
        reduceTransparencyEnabled: Bool = false,
        increasedContrastEnabled: Bool = false
    ) {
        self.reduceTransparencyEnabled = reduceTransparencyEnabled
        self.increasedContrastEnabled = increasedContrastEnabled
    }

    public var prefersOpaqueSurface: Bool {
        reduceTransparencyEnabled || increasedContrastEnabled
    }

    public static func runtimeDefault() -> DSAccessibilitySnapshot {
#if canImport(UIKit)
        return DSAccessibilitySnapshot(
            reduceTransparencyEnabled: UIAccessibility.isReduceTransparencyEnabled,
            increasedContrastEnabled: UIAccessibility.isDarkerSystemColorsEnabled
        )
#else
        return DSAccessibilitySnapshot()
#endif
    }
}

public struct DSStyleCapabilitySnapshot: Sendable, Equatable {
    public let supportsGlassMaterial: Bool
    public let accessibility: DSAccessibilitySnapshot

    public init(
        supportsGlassMaterial: Bool,
        accessibility: DSAccessibilitySnapshot = .runtimeDefault()
    ) {
        self.supportsGlassMaterial = supportsGlassMaterial
        self.accessibility = accessibility
    }

    public static func runtimeDefault() -> DSStyleCapabilitySnapshot {
        DSStyleCapabilitySnapshot(
            supportsGlassMaterial: true,
            accessibility: .runtimeDefault()
        )
    }
}

public struct DSVisualStyleResolutionContext: Sendable, Equatable {
    public let prefersOpaqueSurface: Bool?

    public init(prefersOpaqueSurface: Bool? = nil) {
        self.prefersOpaqueSurface = prefersOpaqueSurface
    }
}

public enum DSVisualStyleResolver {
    public static func resolve(
        requestedStyle: DSVisualStyle,
        capability: DSStyleCapabilitySnapshot,
        context: DSVisualStyleResolutionContext = DSVisualStyleResolutionContext()
    ) -> DSVisualStyle {
        guard requestedStyle == .glass else {
            return .nonGlass
        }

        let prefersOpaqueSurface =
            context.prefersOpaqueSurface ?? capability.accessibility.prefersOpaqueSurface
        if prefersOpaqueSurface {
            return .nonGlass
        }

        return capability.supportsGlassMaterial ? .glass : .nonGlass
    }
}

public struct DSVisualStylePolicy: Sendable, Equatable {
    public var themeMode: DSThemeMode
    public var visualStyle: DSVisualStyle

    public init(
        themeMode: DSThemeMode = .system,
        visualStyle: DSVisualStyle = .nonGlass
    ) {
        self.themeMode = themeMode
        self.visualStyle = visualStyle
    }

    public static let standard = DSVisualStylePolicy()

    public func resolveColorScheme(system: ColorScheme) -> ColorScheme {
        switch themeMode {
        case .system:
            return system
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    public func resolveVisualStyle(
        capability: DSStyleCapabilitySnapshot,
        context: DSVisualStyleResolutionContext = DSVisualStyleResolutionContext()
    ) -> DSVisualStyle {
        DSVisualStyleResolver.resolve(
            requestedStyle: visualStyle,
            capability: capability,
            context: context
        )
    }
}

private struct DSVisualStylePolicyEnvironmentKey: EnvironmentKey {
    static let defaultValue: DSVisualStylePolicy = .standard
}

private struct DSStyleCapabilitySnapshotEnvironmentKey: EnvironmentKey {
    static let defaultValue: DSStyleCapabilitySnapshot = .runtimeDefault()
}

public extension EnvironmentValues {
    var dsVisualStylePolicy: DSVisualStylePolicy {
        get { self[DSVisualStylePolicyEnvironmentKey.self] }
        set { self[DSVisualStylePolicyEnvironmentKey.self] = newValue }
    }

    var dsSurfaceCapabilitySnapshot: DSStyleCapabilitySnapshot {
        get { self[DSStyleCapabilitySnapshotEnvironmentKey.self] }
        set { self[DSStyleCapabilitySnapshotEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func dsVisualStylePolicy(_ policy: DSVisualStylePolicy) -> some View {
        modifier(DSVisualStylePolicyModifier(policy: policy))
    }

    func dsThemeMode(_ mode: DSThemeMode) -> some View {
        modifier(DSThemeModeModifier(mode: mode))
    }

    func dsVisualStyle(_ style: DSVisualStyle) -> some View {
        modifier(DSVisualStyleModifier(style: style))
    }

    func dsSurfaceCapabilitySnapshot(_ snapshot: DSStyleCapabilitySnapshot) -> some View {
        environment(\.dsSurfaceCapabilitySnapshot, snapshot)
    }

    func dsRuntimeSurfaceCapabilityBridge(
        supportsGlassMaterial: Bool = DSStyleCapabilitySnapshot.runtimeDefault().supportsGlassMaterial
    ) -> some View {
        modifier(
            DSRuntimeSurfaceCapabilityBridgeModifier(
                supportsGlassMaterial: supportsGlassMaterial
            )
        )
    }
}

private struct DSVisualStylePolicyModifier: ViewModifier {
    let policy: DSVisualStylePolicy
    @Environment(\.colorScheme) private var systemColorScheme

    func body(content: Content) -> some View {
        content
            .environment(\.dsVisualStylePolicy, policy)
            .environment(\.colorScheme, policy.resolveColorScheme(system: systemColorScheme))
    }
}

private struct DSThemeModeModifier: ViewModifier {
    let mode: DSThemeMode
    @Environment(\.dsVisualStylePolicy) private var currentPolicy
    @Environment(\.colorScheme) private var systemColorScheme

    func body(content: Content) -> some View {
        let updated = DSVisualStylePolicy(
            themeMode: mode,
            visualStyle: currentPolicy.visualStyle
        )
        return content
            .environment(\.dsVisualStylePolicy, updated)
            .environment(\.colorScheme, updated.resolveColorScheme(system: systemColorScheme))
    }
}

private struct DSVisualStyleModifier: ViewModifier {
    let style: DSVisualStyle
    @Environment(\.dsVisualStylePolicy) private var currentPolicy
    @Environment(\.colorScheme) private var systemColorScheme

    func body(content: Content) -> some View {
        let updated = DSVisualStylePolicy(
            themeMode: currentPolicy.themeMode,
            visualStyle: style
        )
        return content
            .environment(\.dsVisualStylePolicy, updated)
            .environment(\.colorScheme, updated.resolveColorScheme(system: systemColorScheme))
    }
}

private struct DSRuntimeSurfaceCapabilityBridgeModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var accessibilityReduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private let supportsGlassMaterial: Bool

    init(supportsGlassMaterial: Bool) {
        self.supportsGlassMaterial = supportsGlassMaterial
    }

    func body(content: Content) -> some View {
        let snapshot = DSStyleCapabilitySnapshot(
            supportsGlassMaterial: supportsGlassMaterial,
            accessibility: DSAccessibilitySnapshot(
                reduceTransparencyEnabled: accessibilityReduceTransparency,
                increasedContrastEnabled: colorSchemeContrast == .increased
            )
        )
        content.environment(\.dsSurfaceCapabilitySnapshot, snapshot)
    }
}
