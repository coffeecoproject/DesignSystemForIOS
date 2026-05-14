import XCTest
@testable import DesignSystemForIOS

final class DSSemanticMappingTests: XCTestCase {
    func testSemanticAccentMapsToBrandCoreToken() {
        XCTAssertEqual(DSSemanticColorTokens.accentPrimary, DSCoreColorTokens.brand500)
    }

    func testSemanticPageBackgroundMapsToNeutralCoreToken() {
        XCTAssertEqual(DSSemanticColorTokens.bgPage, DSCoreColorTokens.neutral50)
    }
}
