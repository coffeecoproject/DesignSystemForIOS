import SwiftUI

public struct DSStateView: View {
    public enum Kind: Equatable {
        case loading(text: String)
        case empty(title: String, detail: String?)
        case error(message: String, retryTitle: String)
    }

    private let kind: Kind
    private let onRetry: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    public init(
        _ kind: Kind,
        onRetry: (() -> Void)? = nil
    ) {
        self.kind = kind
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: DSSemanticSpacingTokens.stackRegular) {
            switch kind {
            case .loading(let text):
                ProgressView()
                Text(text)
                    .dsTextStyle(DSTypographyTokens.bodyM)
                    .foregroundStyle(DSSemanticColorTokens.textSecondary.resolved(in: colorScheme))

            case .empty(let title, let detail):
                Image(systemName: "tray")
                    .dsTextStyle(DSTypographyTokens.titleS)
                    .foregroundStyle(DSSemanticColorTokens.textSecondary.resolved(in: colorScheme))
                Text(title)
                    .dsTextStyle(DSTypographyTokens.bodyL)
                    .foregroundStyle(DSSemanticColorTokens.textPrimary.resolved(in: colorScheme))
                    .multilineTextAlignment(.center)
                if let detail, !detail.isEmpty {
                    Text(detail)
                        .dsTextStyle(DSTypographyTokens.bodyS)
                        .foregroundStyle(DSSemanticColorTokens.textSecondary.resolved(in: colorScheme))
                        .multilineTextAlignment(.center)
                }

            case .error(let message, let retryTitle):
                Image(systemName: "exclamationmark.triangle.fill")
                    .dsTextStyle(DSTypographyTokens.titleS)
                    .foregroundStyle(DSSemanticColorTokens.stateDanger.resolved(in: colorScheme))
                Text(message)
                    .dsTextStyle(DSTypographyTokens.bodyM)
                    .foregroundStyle(DSSemanticColorTokens.textPrimary.resolved(in: colorScheme))
                    .multilineTextAlignment(.center)
                if let onRetry {
                    Button(action: onRetry) {
                        Text(retryTitle)
                            .dsTextStyle(DSTypographyTokens.labelM)
                            .foregroundStyle(DSSemanticColorTokens.textPrimary.resolved(in: colorScheme))
                            .frame(maxWidth: .infinity, minHeight: DSDimensionTokens.d40)
                            .padding(.horizontal, DSSpacingTokens.s16)
                            .background(
                                RoundedRectangle(cornerRadius: DSRadiusTokens.r12, style: .continuous)
                                    .fill(DSSemanticColorTokens.bgSurface.resolved(in: colorScheme))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DSRadiusTokens.r12, style: .continuous)
                                            .stroke(DSSemanticColorTokens.strokeSoft.resolved(in: colorScheme), lineWidth: DSStrokeTokens.regular)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: 220)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(DSSemanticSpacingTokens.sectionGap)
    }
}
