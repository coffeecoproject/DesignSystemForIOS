import SwiftUI

public struct DSSheetScaffold<Content: View, Footer: View>: View {
    private let title: String
    private let subtitle: String?
    private let content: Content
    private let footer: Footer

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        DSSurface(
            style: .surface,
            cornerRadius: DSRadiusTokens.r20,
            padding: DSSpacingTokens.s16,
            shadow: DSShadowTokens.popup
        ) {
            VStack(alignment: .leading, spacing: DSSemanticSpacingTokens.stackRegular) {
                VStack(alignment: .leading, spacing: DSSpacingTokens.s4) {
                    Text(title)
                        .dsTextStyle(DSTypographyTokens.titleS)

                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .dsTextStyle(DSTypographyTokens.bodyS)
                            .foregroundStyle(DSSemanticColorTokens.textSecondary.resolved(in: colorScheme))
                    }
                }

                content

                footer
            }
        }
    }

    @Environment(\.colorScheme) private var colorScheme
}
