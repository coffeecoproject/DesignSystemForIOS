import CoreGraphics

public struct DSShadowToken: Sendable, Equatable {
    public let radius: CGFloat
    public let y: CGFloat
    public let opacity: CGFloat

    public init(
        radius: CGFloat,
        y: CGFloat,
        opacity: CGFloat
    ) {
        self.radius = radius
        self.y = y
        self.opacity = min(max(0, opacity), 1)
    }
}

public enum DSShadowTokens {
    public static let none = DSShadowToken(radius: 0, y: 0, opacity: 0)
    public static let card = DSShadowToken(radius: 8, y: 2, opacity: 0.10)
    public static let popup = DSShadowToken(radius: 16, y: 4, opacity: 0.16)
}
