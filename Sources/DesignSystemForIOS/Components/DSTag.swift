import SwiftUI

public enum DSTagVariant: Sendable, Equatable {
    case neutral
    case info
    case success
    case warning
    case danger
}

public struct DSTag: View {
    private let title: String
    private let variant: DSTagVariant

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot

    public init(
        _ title: String,
        variant: DSTagVariant = .neutral
    ) {
        self.title = title
        self.variant = variant
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let resolvedVisualStyle = visualPolicy.resolveVisualStyle(
            capability: surfaceCapabilitySnapshot
        )

        Text(title)
            .dsTextStyle(DSTypographyTokens.labelS)
            .foregroundStyle(foregroundToken.resolved(in: resolvedColorScheme))
            .padding(.horizontal, DSSpacingTokens.s8)
            .padding(.vertical, DSSpacingTokens.s4)
            .background(
                tagBackground(
                    colorScheme: resolvedColorScheme,
                    visualStyle: resolvedVisualStyle
                )
            )
            .environment(\.colorScheme, resolvedColorScheme)
    }
}

private extension DSTag {
    @ViewBuilder
    func tagBackground(
        colorScheme: ColorScheme,
        visualStyle: DSVisualStyle
    ) -> some View {
        let capsule = Capsule(style: .continuous)

        if visualStyle == .glass, variant == .neutral {
            capsule
                .fill(DSSemanticColorTokens.glassFill.resolved(in: colorScheme))
                .background(.ultraThinMaterial, in: capsule)
                .overlay(
                    capsule.stroke(DSSemanticColorTokens.glassStroke.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                )
        } else {
            capsule
                .fill(backgroundToken.resolved(in: colorScheme))
        }
    }

    var foregroundToken: DSColorToken {
        switch variant {
        case .neutral:
            return DSSemanticColorTokens.textPrimary
        case .info:
            return DSSemanticColorTokens.textInverse
        case .success:
            return DSSemanticColorTokens.textInverse
        case .warning:
            return DSSemanticColorTokens.textInverse
        case .danger:
            return DSSemanticColorTokens.textInverse
        }
    }

    var backgroundToken: DSColorToken {
        switch variant {
        case .neutral:
            return DSSemanticColorTokens.bgMuted
        case .info:
            return DSSemanticColorTokens.stateInfo
        case .success:
            return DSSemanticColorTokens.stateSuccess
        case .warning:
            return DSSemanticColorTokens.stateWarning
        case .danger:
            return DSSemanticColorTokens.stateDanger
        }
    }
}
