import SwiftUI

public struct DSContainer<Content: View>: View {
    private let maxWidth: CGFloat?
    private let horizontalInset: CGFloat
    private let verticalInset: CGFloat
    private let alignment: HorizontalAlignment
    private let content: Content

    public init(
        maxWidth: CGFloat? = 640,
        horizontalInset: CGFloat = DSSemanticSpacingTokens.screenInset,
        verticalInset: CGFloat = DSSpacingTokens.s12,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content
    ) {
        self.maxWidth = maxWidth
        self.horizontalInset = horizontalInset
        self.verticalInset = verticalInset
        self.alignment = alignment
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: DSSemanticSpacingTokens.stackRegular) {
            content
        }
        .frame(maxWidth: maxWidth ?? .infinity, alignment: .leading)
        .padding(.horizontal, horizontalInset)
        .padding(.vertical, verticalInset)
    }
}
