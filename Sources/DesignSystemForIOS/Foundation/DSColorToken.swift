import SwiftUI

public struct DSColorToken: Sendable, Equatable, Hashable {
    public let light: DSRGBA
    public let dark: DSRGBA

    public init(
        light: DSRGBA,
        dark: DSRGBA
    ) {
        self.light = light
        self.dark = dark
    }

    public func rgba(for scheme: ColorScheme) -> DSRGBA {
        switch scheme {
        case .light:
            return light
        case .dark:
            return dark
        @unknown default:
            return light
        }
    }

    public func resolved(in scheme: ColorScheme) -> Color {
        rgba(for: scheme).color
    }
}

public extension DSRGBA {
    var color: Color {
        Color(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            opacity: Double(alpha)
        )
    }
}

public extension Color {
    static func ds(
        _ token: DSColorToken,
        in scheme: ColorScheme
    ) -> Color {
        token.resolved(in: scheme)
    }
}
