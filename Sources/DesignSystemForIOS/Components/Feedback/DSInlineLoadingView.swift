import SwiftUI

public struct DSInlineLoadingView: View {
    private let title: String
    private let detail: String?

    @Environment(\.colorScheme) private var colorScheme

    public init(
        title: String,
        detail: String? = nil
    ) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        HStack(alignment: .center, spacing: DSSpacingTokens.s8) {
            ProgressView()

            VStack(alignment: .leading, spacing: DSSpacingTokens.s2) {
                Text(title)
                    .dsTextStyle(DSTypographyTokens.bodyM)
                    .foregroundStyle(DSSemanticColorTokens.textPrimary.resolved(in: colorScheme))

                if let detail, !detail.isEmpty {
                    Text(detail)
                        .dsTextStyle(DSTypographyTokens.bodyS)
                        .foregroundStyle(DSSemanticColorTokens.textSecondary.resolved(in: colorScheme))
                        .lineLimit(2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
