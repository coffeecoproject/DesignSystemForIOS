import SwiftUI

public enum DSMotionTokens {
    public static let quick: Double = 0.16
    public static let regular: Double = 0.24
    public static let slow: Double = 0.32

    public static var emphasize: Animation {
        .spring(response: 0.30, dampingFraction: 0.85)
    }
}
