import SwiftUI

public struct DSSurface<Content: View>: View {
    public struct RenderSpec: Sendable, Equatable {
        public let fillToken: DSColorToken
        public let strokeToken: DSColorToken
        public let shadowColorToken: DSColorToken
        public let shadow: DSShadowToken
        public let usesGlassMaterial: Bool

        public init(
            fillToken: DSColorToken,
            strokeToken: DSColorToken,
            shadowColorToken: DSColorToken,
            shadow: DSShadowToken,
            usesGlassMaterial: Bool
        ) {
            self.fillToken = fillToken
            self.strokeToken = strokeToken
            self.shadowColorToken = shadowColorToken
            self.shadow = shadow
            self.usesGlassMaterial = usesGlassMaterial
        }
    }

    public enum Style: Sendable, Equatable {
        case page
        case surface
        case muted
        case accent
    }

    private let style: Style
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let shadow: DSShadowToken
    private let content: Content

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot

    public init(
        style: Style = .surface,
        cornerRadius: CGFloat = DSRadiusTokens.r16,
        padding: CGFloat = DSSpacingTokens.s16,
        shadow: DSShadowToken = DSShadowTokens.none,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadow = shadow
        self.content = content()
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let resolvedVisualStyle = visualPolicy.resolveVisualStyle(
            capability: surfaceCapabilitySnapshot
        )
        let spec = Self.renderSpec(
            style: style,
            visualStyle: resolvedVisualStyle,
            baseShadow: shadow
        )

        content
            .environment(\.colorScheme, resolvedColorScheme)
            .padding(padding)
            .background(
                surfaceBackground(
                    spec: spec,
                    colorScheme: resolvedColorScheme
                )
            )
    }
}

extension DSSurface {
    public static func renderSpec(
        style: Style,
        policy: DSVisualStylePolicy,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault(),
        baseShadow: DSShadowToken
    ) -> RenderSpec {
        renderSpec(
            style: style,
            visualStyle: policy.resolveVisualStyle(capability: capability),
            baseShadow: baseShadow
        )
    }

    @ViewBuilder
    private func surfaceBackground(
        spec: RenderSpec,
        colorScheme: ColorScheme
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        if spec.usesGlassMaterial {
            shape
                .fill(spec.fillToken.resolved(in: colorScheme))
                .background(.ultraThinMaterial, in: shape)
                .overlay(
                    shape.stroke(spec.strokeToken.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                )
                .shadow(
                    color: spec.shadowColorToken
                        .resolved(in: colorScheme)
                        .opacity(spec.shadow.opacity),
                    radius: spec.shadow.radius,
                    x: 0,
                    y: spec.shadow.y
                )
        } else {
            shape
                .fill(spec.fillToken.resolved(in: colorScheme))
                .overlay(
                    shape.stroke(spec.strokeToken.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                )
                .shadow(
                    color: spec.shadowColorToken
                        .resolved(in: colorScheme)
                        .opacity(spec.shadow.opacity),
                    radius: spec.shadow.radius,
                    x: 0,
                    y: spec.shadow.y
                )
        }
    }

    public static func renderSpec(
        style: Style,
        visualStyle: DSVisualStyle,
        baseShadow: DSShadowToken
    ) -> RenderSpec {
        let fillToken: DSColorToken
        let strokeToken: DSColorToken

        switch style {
        case .page:
            fillToken = DSSemanticColorTokens.bgPage
            strokeToken = DSSemanticColorTokens.bgPage
        case .surface:
            fillToken = DSSemanticColorTokens.bgSurface
            strokeToken = DSSemanticColorTokens.strokeSoft
        case .muted:
            fillToken = DSSemanticColorTokens.bgMuted
            strokeToken = DSSemanticColorTokens.strokeSoft
        case .accent:
            fillToken = DSSemanticColorTokens.accentSoft
            strokeToken = DSSemanticColorTokens.accentPrimary
        }

        if visualStyle == .glass {
            let glassShadow = baseShadow.isNone ? DSShadowTokens.card : baseShadow
            return RenderSpec(
                fillToken: DSSemanticColorTokens.glassFill,
                strokeToken: DSSemanticColorTokens.glassStroke,
                shadowColorToken: DSSemanticColorTokens.glassShadow,
                shadow: glassShadow,
                usesGlassMaterial: true
            )
        }

        return RenderSpec(
            fillToken: fillToken,
            strokeToken: strokeToken,
            shadowColorToken: DSSemanticColorTokens.textPrimary,
            shadow: baseShadow,
            usesGlassMaterial: false
        )
    }
}

private extension DSShadowToken {
    var isNone: Bool {
        radius == 0 && y == 0 && opacity == 0
    }
}
