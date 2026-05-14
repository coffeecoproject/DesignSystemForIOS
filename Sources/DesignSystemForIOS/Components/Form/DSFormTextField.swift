import SwiftUI

public enum DSFormFieldState: Sendable, Equatable {
    case normal
    case disabled
    case error(message: String?)
}

public struct DSFormFieldStyleSpec: Sendable, Equatable {
    public let background: DSColorToken
    public let border: DSColorToken
    public let text: DSColorToken
    public let placeholder: DSColorToken
    public let message: DSColorToken
    public let usesGlassMaterial: Bool
    public let cornerRadius: CGFloat

    public init(
        background: DSColorToken,
        border: DSColorToken,
        text: DSColorToken,
        placeholder: DSColorToken,
        message: DSColorToken,
        usesGlassMaterial: Bool,
        cornerRadius: CGFloat
    ) {
        self.background = background
        self.border = border
        self.text = text
        self.placeholder = placeholder
        self.message = message
        self.usesGlassMaterial = usesGlassMaterial
        self.cornerRadius = cornerRadius
    }
}

public struct DSFormTextField: View {
    private let title: String?
    private let placeholder: String
    @Binding private var text: String
    private let state: DSFormFieldState

    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dsVisualStylePolicy) private var visualPolicy
    @Environment(\.dsSurfaceCapabilitySnapshot) private var surfaceCapabilitySnapshot
    @Environment(\.dsAccessibilityPolicy) private var accessibilityPolicy

    public init(
        title: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        state: DSFormFieldState = .normal
    ) {
        self.title = title
        self.placeholder = placeholder
        _text = text
        self.state = state
    }

    public var body: some View {
        let resolvedColorScheme = visualPolicy.resolveColorScheme(system: systemColorScheme)
        let spec = Self.styleSpec(
            state: state,
            policy: visualPolicy,
            capability: surfaceCapabilitySnapshot
        )

        VStack(alignment: .leading, spacing: DSSpacingTokens.s4) {
            if let title, !title.isEmpty {
                Text(title)
                    .dsTextStyle(DSTypographyTokens.labelM)
                    .foregroundStyle(DSSemanticColorTokens.textPrimary.resolved(in: resolvedColorScheme))
            }

            ZStack(alignment: .leading) {
                if text.isEmpty, !placeholder.isEmpty {
                    Text(placeholder)
                        .dsTextStyle(DSTypographyTokens.bodyM)
                        .foregroundStyle(spec.placeholder.resolved(in: resolvedColorScheme))
                        .padding(.horizontal, DSSpacingTokens.s12)
                }

                TextField("", text: $text)
                    .disabled(state.isDisabled)
                    .dsTextStyle(DSTypographyTokens.bodyM)
                    .foregroundStyle(spec.text.resolved(in: resolvedColorScheme))
                    .padding(.horizontal, DSSpacingTokens.s12)
                    .frame(minHeight: max(DSDimensionTokens.d44, accessibilityPolicy.minimumHitTarget))
                    .accessibilityLabel(title ?? placeholder)
            }
            .background(
                fieldBackground(
                    spec: spec,
                    colorScheme: resolvedColorScheme
                )
            )

            if case .error(let message) = state, let message, !message.isEmpty {
                Text(message)
                    .dsTextStyle(DSTypographyTokens.bodyS)
                    .foregroundStyle(spec.message.resolved(in: resolvedColorScheme))
            }
        }
        .environment(\.colorScheme, resolvedColorScheme)
    }
}

public extension DSFormTextField {
    static func styleSpec(
        state: DSFormFieldState,
        policy: DSVisualStylePolicy = .standard,
        capability: DSStyleCapabilitySnapshot = .runtimeDefault()
    ) -> DSFormFieldStyleSpec {
        let resolvedVisualStyle = policy.resolveVisualStyle(capability: capability)

        let base = DSFormFieldStyleSpec(
            background: DSSemanticColorTokens.bgSurface,
            border: DSSemanticColorTokens.strokeSoft,
            text: DSSemanticColorTokens.textPrimary,
            placeholder: DSSemanticColorTokens.textSecondary,
            message: DSSemanticColorTokens.stateDanger,
            usesGlassMaterial: resolvedVisualStyle == .glass,
            cornerRadius: DSRadiusTokens.r12
        )

        switch state {
        case .normal:
            return base
        case .disabled:
            return DSFormFieldStyleSpec(
                background: DSSemanticColorTokens.bgMuted,
                border: DSSemanticColorTokens.bgMuted,
                text: DSSemanticColorTokens.textSecondary,
                placeholder: DSSemanticColorTokens.textSecondary,
                message: base.message,
                usesGlassMaterial: false,
                cornerRadius: base.cornerRadius
            )
        case .error:
            return DSFormFieldStyleSpec(
                background: base.background,
                border: DSSemanticColorTokens.stateDanger,
                text: base.text,
                placeholder: base.placeholder,
                message: base.message,
                usesGlassMaterial: base.usesGlassMaterial,
                cornerRadius: base.cornerRadius
            )
        }
    }
}

private extension DSFormTextField {
    @ViewBuilder
    func fieldBackground(
        spec: DSFormFieldStyleSpec,
        colorScheme: ColorScheme
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)

        if spec.usesGlassMaterial {
            shape
                .fill(DSSemanticColorTokens.glassFill.resolved(in: colorScheme))
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

private extension DSFormFieldState {
    var isDisabled: Bool {
        if case .disabled = self {
            return true
        }
        return false
    }
}
