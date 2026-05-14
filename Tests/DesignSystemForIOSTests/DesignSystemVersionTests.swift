import XCTest
@testable import DesignSystemForIOS

final class DesignSystemVersionTests: XCTestCase {
    func testVersionIsSemanticVersionLike() {
        let parts = DesignSystem.version.split(separator: ".")
        XCTAssertEqual(parts.count, 3)
        XCTAssertTrue(parts.allSatisfy { Int($0) != nil })
    }
}
