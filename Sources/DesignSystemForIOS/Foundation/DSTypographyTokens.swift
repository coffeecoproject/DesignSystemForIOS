import CoreGraphics
import SwiftUI

public enum DSFontWeight: Sendable, Equatable {
    case regular
    case medium
    case semibold
    case bold

    var swiftUIWeight: Font.Weight {
        switch self {
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        }
    }
}

public enum DSFontDesign: Sendable, Equatable {
    case `default`
    case rounded
    case monospaced

    var swiftUIDesign: Font.Design {
        switch self {
        case .default:
            return .default
        case .rounded:
            return .rounded
        case .monospaced:
            return .monospaced
        }
    }
}

public struct DSFontToken: Sendable, Equatable {
    public let size: CGFloat
    public let weight: DSFontWeight
    public let design: DSFontDesign

    public init(
        size: CGFloat,
        weight: DSFontWeight = .regular,
        design: DSFontDesign = .default
    ) {
        self.size = size
        self.weight = weight
        self.design = design
    }

    public var font: Font {
        .system(
            size: size,
            weight: weight.swiftUIWeight,
            design: design.swiftUIDesign
        )
    }
}

public enum DSTypographyTokens {
    public static let titleL = DSFontToken(size: 28, weight: .bold)
    public static let titleM = DSFontToken(size: 24, weight: .semibold)
    public static let titleS = DSFontToken(size: 20, weight: .semibold)
    public static let bodyL = DSFontToken(size: 17, weight: .regular)
    public static let bodyM = DSFontToken(size: 15, weight: .regular)
    public static let bodyS = DSFontToken(size: 13, weight: .regular)
    public static let labelL = DSFontToken(size: 16, weight: .semibold)
    public static let labelM = DSFontToken(size: 14, weight: .semibold)
    public static let labelS = DSFontToken(size: 12, weight: .medium)
}

public extension View {
    func dsTextStyle(_ token: DSFontToken) -> some View {
        font(token.font)
    }
}
