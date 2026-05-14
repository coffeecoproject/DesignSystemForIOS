import SwiftUI

public struct DSTopBarAction {
    public let systemImage: String
    public let accessibilityLabel: String
    public let action: () -> Void

    public init(
        systemImage: String,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }
}

public struct DSTopBarStyleSpec: Sendable, Equatable {
    public let background: DSColorToken
    public let border: DSColorToken
    public let titleColor: DSColorToken
    public let subtitleColor: DSColorToken
    public let actionColor: DSColorToken
    public let usesGlassMaterial: Bool

    public init(
        background: DSColorToken,
        border: DSColorToken,
        titleColor: DSColorToken,
        subtitleColor: DSColorToken,
        actionColor: DSColorToken,
        usesGlassMaterial: Bool
    ) {
        self.background = background
        self.border = border
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.actionColor = actionColor
        self.usesGlassMaterial = usesGlassMaterial
    }
}

public struct DSTopBar: View {
    private let title: String
    private let subtitle: String?
    private let leadingAction: DSTopBarAction?
    private let trailingActions: [DSTopBarAction]

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    public init(
        title: String,
        subtitle: String? = nil,
        leadingAction: DSTopBarAction? = nil,
        trailingActions: [DSTopBarAction] = []
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingAction = leadingAction
        self.trailingActions = trailingActions
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let spec = Self.styleSpec(
            policy: visualPolicy,
            capability: surfaceCapabilitySnapshot
        )

        HStack(spacing: DSSpacingTokens.s12) {
            actionButton(
                action: leadingAction,
                spec: spec,
                colorScheme: resolvedColorScheme
            )

            VStack(alignment: .leading, spacing: DSSpacingTokens.s2) {
                Text(title)
                    .dsTextStyle(DSTypographyTokens.titleS)
                    .foregroundStyle(spec.titleColor.resolved(in: resolvedColorScheme))
                    .lineLimit(1)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .dsTextStyle(DSTypographyTokens.bodyS)
                        .foregroundStyle(spec.subtitleColor.resolved(in: resolvedColorScheme))
                        .lineLimit(1)
                }
            }

            Spacer(minLength: DSSpacingTokens.s8)

            HStack(spacing: DSSpacingTokens.s8) {
                ForEach(Array(trailingActions.enumerated()), id: \.offset) { item in
                    actionButton(
                        action: item.element,
                        spec: spec,
                        colorScheme: resolvedColorScheme
                    )
                }
            }
        }
        .padding(.horizontal, DSSpacingTokens.s12)
        .padding(.vertical, DSSpacingTokens.s10)
        .background(
            barBackground(
                spec: spec,
                colorScheme: resolvedColorScheme
            )
        )
        .environment(\.colorScheme, resolvedColorScheme)
    }
}

public extension DSTopBar {
    static func styleSpec(
        policy: DSVisualStylePolicy = .standard,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault()
    ) -> DSTopBarStyleSpec {
        let resolvedVisualStyle = policy.resolveVisualStyle(capability: capability)

        if resolvedVisualStyle == .glass {
            return DSTopBarStyleSpec(
                background: DSSemanticColorTokens.glassFill,
                border: DSSemanticColorTokens.glassStroke,
                titleColor: DSSemanticColorTokens.textPrimary,
                subtitleColor: DSSemanticColorTokens.textSecondary,
                actionColor: DSSemanticColorTokens.textPrimary,
                usesGlassMaterial: true
            )
        }

        return DSTopBarStyleSpec(
            background: DSSemanticColorTokens.bgSurface,
            border: DSSemanticColorTokens.strokeSoft,
            titleColor: DSSemanticColorTokens.textPrimary,
            subtitleColor: DSSemanticColorTokens.textSecondary,
            actionColor: DSSemanticColorTokens.textPrimary,
            usesGlassMaterial: false
        )
    }
}

private extension DSTopBar {
    @ViewBuilder
    func barBackground(
        spec: DSTopBarStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: DSRadiusTokens.r16, style: .continuous)

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

    @ViewBuilder
    func actionButton(
        action: DSTopBarAction?,
        spec: DSTopBarStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        if let action {
            Button(action: action.action) {
                Image(systemName: action.systemImage)
                    .dsTextStyle(DSTypographyTokens.labelM)
                    .foregroundStyle(spec.actionColor.resolved(in: colorScheme))
                    .frame(
                        width: max(DSDimensionTokens.d32, accessibilityPolicy.minimumHitTarget),
                        height: max(DSDimensionTokens.d32, accessibilityPolicy.minimumHitTarget)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(action.accessibilityLabel)
        } else {
            Color.clear
                .frame(
                    width: max(DSDimensionTokens.d32, accessibilityPolicy.minimumHitTarget),
                    height: max(DSDimensionTokens.d32, accessibilityPolicy.minimumHitTarget)
                )
        }
    }
}
