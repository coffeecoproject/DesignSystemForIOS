import SwiftUI

public enum DSListRowAccessory: Sendable, Equatable {
    case none
    case disclosure
    case text(String)
    case badge(String)
}

public struct DSListRowStyleSpec: Sendable, Equatable {
    public let background: DSColorToken
    public let border: DSColorToken
    public let titleColor: DSColorToken
    public let subtitleColor: DSColorToken
    public let accessoryColor: DSColorToken
    public let usesGlassMaterial: Bool

    public init(
        background: DSColorToken,
        border: DSColorToken,
        titleColor: DSColorToken,
        subtitleColor: DSColorToken,
        accessoryColor: DSColorToken,
        usesGlassMaterial: Bool
    ) {
        self.background = background
        self.border = border
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.accessoryColor = accessoryColor
        self.usesGlassMaterial = usesGlassMaterial
    }
}

public struct DSListRow: View {
    private let title: String
    private let subtitle: String?
    private let accessory: DSListRowAccessory
    private let onTap: (() -> Void)?

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot

    public init(
        title: String,
        subtitle: String? = nil,
        accessory: DSListRowAccessory = .none,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
        self.onTap = onTap
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let spec = Self.styleSpec(
            policy: visualPolicy,
            capability: surfaceCapabilitySnapshot
        )

        let rowContent = HStack(alignment: .center, spacing: DSSpacingTokens.s12) {
            VStack(alignment: .leading, spacing: DSSpacingTokens.s2) {
                Text(title)
                    .dsTextStyle(DSTypographyTokens.bodyL)
                    .foregroundStyle(spec.titleColor.resolved(in: resolvedColorScheme))
                    .lineLimit(1)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .dsTextStyle(DSTypographyTokens.bodyS)
                        .foregroundStyle(spec.subtitleColor.resolved(in: resolvedColorScheme))
                        .lineLimit(2)
                }
            }

            Spacer(minLength: DSSpacingTokens.s8)

            accessoryView(
                accessory: accessory,
                spec: spec,
                colorScheme: resolvedColorScheme
            )
        }
        .padding(.horizontal, DSSpacingTokens.s12)
        .padding(.vertical, DSSpacingTokens.s10)
        .background(
            rowBackground(
                spec: spec,
                colorScheme: resolvedColorScheme
            )
        )
        .contentShape(Rectangle())
        .environment(\.colorScheme, resolvedColorScheme)

        if let onTap {
            Button(action: onTap) {
                rowContent
            }
            .buttonStyle(.plain)
        } else {
            rowContent
        }
    }
}

public extension DSListRow {
    static func styleSpec(
        policy: DSVisualStylePolicy = .standard,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault()
    ) -> DSListRowStyleSpec {
        let resolvedVisualStyle = policy.resolveVisualStyle(capability: capability)

        if resolvedVisualStyle == .glass {
            return DSListRowStyleSpec(
                background: DSSemanticColorTokens.glassFill,
                border: DSSemanticColorTokens.glassStroke,
                titleColor: DSSemanticColorTokens.textPrimary,
                subtitleColor: DSSemanticColorTokens.textSecondary,
                accessoryColor: DSSemanticColorTokens.textSecondary,
                usesGlassMaterial: true
            )
        }

        return DSListRowStyleSpec(
            background: DSSemanticColorTokens.bgSurface,
            border: DSSemanticColorTokens.strokeSoft,
            titleColor: DSSemanticColorTokens.textPrimary,
            subtitleColor: DSSemanticColorTokens.textSecondary,
            accessoryColor: DSSemanticColorTokens.textSecondary,
            usesGlassMaterial: false
        )
    }
}

private extension DSListRow {
    @ViewBuilder
    func rowBackground(
        spec: DSListRowStyleSpec,
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

    @ViewBuilder
    func accessoryView(
        accessory: DSListRowAccessory,
        spec: DSListRowStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        switch accessory {
        case .none:
            EmptyView()

        case .disclosure:
            Image(systemName: "chevron.right")
                .dsTextStyle(DSTypographyTokens.labelM)
                .foregroundStyle(spec.accessoryColor.resolved(in: colorScheme))

        case .text(let value):
            Text(value)
                .dsTextStyle(DSTypographyTokens.labelS)
                .foregroundStyle(spec.accessoryColor.resolved(in: colorScheme))

        case .badge(let value):
            Text(value)
                .dsTextStyle(DSTypographyTokens.labelS)
                .foregroundStyle(DSSemanticColorTokens.textInverse.resolved(in: colorScheme))
                .padding(.horizontal, DSSpacingTokens.s8)
                .padding(.vertical, DSSpacingTokens.s4)
                .background(
                    Capsule(style: .continuous)
                        .fill(DSSemanticColorTokens.accentPrimary.resolved(in: colorScheme))
                )
        }
    }
}
