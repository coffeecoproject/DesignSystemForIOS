import SwiftUI

public enum DSButtonVariant: Sendable, Equatable {
    case primary
    case secondary
    case danger
    case ghost
}

public enum DSButtonSize: Sendable, Equatable {
    case small
    case medium
    case large
}

public struct DSButtonStyleSpec: Sendable, Equatable {
    public let background: DSColorToken
    public let foreground: DSColorToken
    public let border: DSColorToken
    public let usesGlassMaterial: Bool
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    public let height: CGFloat
    public let typography: DSFontToken

    public init(
        background: DSColorToken,
        foreground: DSColorToken,
        border: DSColorToken,
        usesGlassMaterial: Bool = false,
        cornerRadius: CGFloat,
        horizontalPadding: CGFloat,
        height: CGFloat,
        typography: DSFontToken
    ) {
        self.background = background
        self.foreground = foreground
        self.border = border
        self.usesGlassMaterial = usesGlassMaterial
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.height = height
        self.typography = typography
    }
}

public struct DSButton: View {
    private let title: String
    private let variant: DSButtonVariant
    private let size: DSButtonSize
    private let isEnabled: Bool
    private let action: () -> Void

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    public init(
        title: String,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        let spec = Self.styleSpec(
            variant: variant,
            size: size,
            isEnabled: isEnabled,
            policy: visualPolicy,
            capability: surfaceCapabilitySnapshot
        )
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)

        Button(action: action) {
            Text(title)
                .dsTextStyle(spec.typography)
                .foregroundStyle(spec.foreground.resolved(in: resolvedColorScheme))
                .lineLimit(1)
                .frame(
                    maxWidth: .infinity,
                    minHeight: max(spec.height, accessibilityPolicy.minimumHitTarget)
                )
                .padding(.horizontal, spec.horizontalPadding)
                .background(buttonBackground(spec: spec, colorScheme: resolvedColorScheme))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.56)
        .environment(\.colorScheme, resolvedColorScheme)
    }
}

public extension DSButton {
    static func styleSpec(
        variant: DSButtonVariant,
        size: DSButtonSize,
        isEnabled: Bool,
        policy: DSVisualStylePolicy = .standard,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault()
    ) -> DSButtonStyleSpec {
        let resolvedVisualStyle = policy.resolveVisualStyle(capability: capability)
        let typography: DSFontToken
        let height: CGFloat
        let horizontalPadding: CGFloat

        switch size {
        case .small:
            typography = DSTypographyTokens.labelS
            height = DSDimensionTokens.d32
            horizontalPadding = DSSpacingTokens.s12
        case .medium:
            typography = DSTypographyTokens.labelM
            height = DSDimensionTokens.d40
            horizontalPadding = DSSpacingTokens.s16
        case .large:
            typography = DSTypographyTokens.labelL
            height = DSDimensionTokens.d48
            horizontalPadding = DSSpacingTokens.s20
        }

        let base: DSButtonStyleSpec
        switch variant {
        case .primary:
            base = DSButtonStyleSpec(
                background: DSSemanticColorTokens.accentPrimary,
                foreground: DSSemanticColorTokens.textInverse,
                border: DSSemanticColorTokens.accentPrimary,
                cornerRadius: DSRadiusTokens.r12,
                horizontalPadding: horizontalPadding,
                height: height,
                typography: typography
            )
        case .secondary:
            base = DSButtonStyleSpec(
                background: DSSemanticColorTokens.bgSurface,
                foreground: DSSemanticColorTokens.textPrimary,
                border: DSSemanticColorTokens.strokeSoft,
                cornerRadius: DSRadiusTokens.r12,
                horizontalPadding: horizontalPadding,
                height: height,
                typography: typography
            )
        case .danger:
            base = DSButtonStyleSpec(
                background: DSSemanticColorTokens.stateDanger,
                foreground: DSSemanticColorTokens.textInverse,
                border: DSSemanticColorTokens.stateDanger,
                cornerRadius: DSRadiusTokens.r12,
                horizontalPadding: horizontalPadding,
                height: height,
                typography: typography
            )
        case .ghost:
            base = DSButtonStyleSpec(
                background: DSSemanticColorTokens.bgPage,
                foreground: DSSemanticColorTokens.accentPrimary,
                border: DSSemanticColorTokens.bgPage,
                cornerRadius: DSRadiusTokens.r12,
                horizontalPadding: horizontalPadding,
                height: height,
                typography: typography
            )
        }

        guard !isEnabled else {
            if resolvedVisualStyle == .glass, variant != .primary, variant != .danger {
                return DSButtonStyleSpec(
                    background: DSSemanticColorTokens.glassFill,
                    foreground: base.foreground,
                    border: DSSemanticColorTokens.glassStroke,
                    usesGlassMaterial: true,
                    cornerRadius: base.cornerRadius,
                    horizontalPadding: base.horizontalPadding,
                    height: base.height,
                    typography: base.typography
                )
            }
            return base
        }

        return DSButtonStyleSpec(
            background: DSSemanticColorTokens.bgMuted,
            foreground: DSSemanticColorTokens.textSecondary,
            border: DSSemanticColorTokens.bgMuted,
            usesGlassMaterial: resolvedVisualStyle == .glass,
            cornerRadius: base.cornerRadius,
            horizontalPadding: base.horizontalPadding,
            height: base.height,
            typography: base.typography
        )
    }
}

private extension DSButton {
    @ViewBuilder
    func buttonBackground(
        spec: DSButtonStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)

        if spec.usesGlassMaterial {
            shape
                .fill(spec.background.resolved(in: colorScheme))
                .background(.ultraThinMaterial, in: shape)
                .overlay(
                    shape.stroke(spec.border.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                )
        } else {
            shape
                .fill(spec.background.resolved(in: colorScheme))
                .overlay(
                    shape.stroke(spec.border.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                )
        }
    }
}
