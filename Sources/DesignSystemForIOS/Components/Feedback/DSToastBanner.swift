import SwiftUI

public enum DSToastKind: Sendable, Equatable {
    case info
    case success
    case warning
    case error
}

public struct DSToastStyleSpec: Sendable, Equatable {
    public let background: DSColorToken
    public let border: DSColorToken
    public let iconColor: DSColorToken
    public let textColor: DSColorToken
    public let usesGlassMaterial: Bool

    public init(
        background: DSColorToken,
        border: DSColorToken,
        iconColor: DSColorToken,
        textColor: DSColorToken,
        usesGlassMaterial: Bool
    ) {
        self.background = background
        self.border = border
        self.iconColor = iconColor
        self.textColor = textColor
        self.usesGlassMaterial = usesGlassMaterial
    }
}

public struct DSToastBanner: View {
    private let message: String
    private let kind: DSToastKind

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot

    public init(
        message: String,
        kind: DSToastKind = .info
    ) {
        self.message = message
        self.kind = kind
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let spec = Self.styleSpec(
            kind: kind,
            policy: visualPolicy,
            capability: surfaceCapabilitySnapshot
        )

        HStack(alignment: .center, spacing: DSSpacingTokens.s8) {
            Image(systemName: iconName(for: kind))
                .dsTextStyle(DSTypographyTokens.labelM)
                .foregroundStyle(spec.iconColor.resolved(in: resolvedColorScheme))

            Text(message)
                .dsTextStyle(DSTypographyTokens.bodyM)
                .foregroundStyle(spec.textColor.resolved(in: resolvedColorScheme))
                .lineLimit(2)

            Spacer(minLength: DSSpacingTokens.s0)
        }
        .padding(.horizontal, DSSpacingTokens.s12)
        .padding(.vertical, DSSpacingTokens.s10)
        .background(
            toastBackground(
                spec: spec,
                colorScheme: resolvedColorScheme
            )
        )
        .environment(\.colorScheme, resolvedColorScheme)
    }
}

public extension DSToastBanner {
    static func styleSpec(
        kind: DSToastKind,
        policy: DSVisualStylePolicy = .standard,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault()
    ) -> DSToastStyleSpec {
        let resolvedVisualStyle = policy.resolveVisualStyle(capability: capability)
        let baseBackground: DSColorToken
        let baseBorder: DSColorToken
        let baseIcon: DSColorToken

        switch kind {
        case .info:
            baseBackground = DSSemanticColorTokens.bgSurface
            baseBorder = DSSemanticColorTokens.strokeSoft
            baseIcon = DSSemanticColorTokens.stateInfo
        case .success:
            baseBackground = DSSemanticColorTokens.bgSurface
            baseBorder = DSSemanticColorTokens.strokeSoft
            baseIcon = DSSemanticColorTokens.stateSuccess
        case .warning:
            baseBackground = DSSemanticColorTokens.bgSurface
            baseBorder = DSSemanticColorTokens.strokeSoft
            baseIcon = DSSemanticColorTokens.stateWarning
        case .error:
            baseBackground = DSSemanticColorTokens.bgSurface
            baseBorder = DSSemanticColorTokens.stateDanger
            baseIcon = DSSemanticColorTokens.stateDanger
        }

        if resolvedVisualStyle == .glass {
            return DSToastStyleSpec(
                background: DSSemanticColorTokens.glassFill,
                border: DSSemanticColorTokens.glassStroke,
                iconColor: baseIcon,
                textColor: DSSemanticColorTokens.textPrimary,
                usesGlassMaterial: true
            )
        }

        return DSToastStyleSpec(
            background: baseBackground,
            border: baseBorder,
            iconColor: baseIcon,
            textColor: DSSemanticColorTokens.textPrimary,
            usesGlassMaterial: false
        )
    }
}

private extension DSToastBanner {
    @ViewBuilder
    func toastBackground(
        spec: DSToastStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: DSRadiusTokens.r12, style: .continuous)

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

    func iconName(for kind: DSToastKind) -> String {
        switch kind {
        case .info:
            return "info.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.octagon.fill"
        }
    }
}
