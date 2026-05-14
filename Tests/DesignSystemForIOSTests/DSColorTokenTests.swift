import SwiftUI
import XCTest
@testable import DesignSystemForIOS

final class DSColorTokenTests: XCTestCase {
    func testRGBAForLightAndDarkSchemes() {
        let token = DSColorToken(
            light: DSRGBA(1, 0, 0),
            dark: DSRGBA(0, 1, 0)
        )

        XCTAssertEqual(token.rgba(for: .light), DSRGBA(1, 0, 0))
        XCTAssertEqual(token.rgba(for: .dark), DSRGBA(0, 1, 0))
    }
}
