import XCTest
@testable import DesignSystemForIOS

final class DSRGBATests: XCTestCase {
    func testInitClampsValuesIntoZeroToOneRange() {
        let rgba = DSRGBA(-0.5, 0.4, 1.2, 3.0)

        XCTAssertEqual(rgba.red, 0)
        XCTAssertEqual(rgba.green, 0.4)
        XCTAssertEqual(rgba.blue, 1)
        XCTAssertEqual(rgba.alpha, 1)
    }
}
