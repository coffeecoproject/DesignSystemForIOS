import XCTest
@testable import DesignSystemForIOS

final class DSComponentStructureTests: XCTestCase {
    func testFormFieldErrorStyleUsesDangerBorder() {
        let spec = DSFormTextField.styleSpec(
            state: .error(message: "Invalid value"),
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .nonGlass)
        )

        XCTAssertEqual(spec.border, DSSemanticColorTokens.stateDanger)
        XCTAssertFalse(spec.usesGlassMaterial)
    }

    func testListRowStyleUsesGlassTokensWhenResolvedAsGlass() {
        let spec = DSListRow.styleSpec(
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass),
            capability: DSStyleCapabilitySnapshot(
                supportsGlassMaterial: true,
                accessibility: DSAccessibilitySnapshot()
            )
        )

        XCTAssertTrue(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.glassFill)
        XCTAssertEqual(spec.border, DSSemanticColorTokens.glassStroke)
    }

    func testToastStyleFallsBackWhenGlassCapabilityDisabled() {
        let spec = DSToastBanner.styleSpec(
            kind: .warning,
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass),
            capability: DSStyleCapabilitySnapshot(
                supportsGlassMaterial: false,
                accessibility: DSAccessibilitySnapshot()
            )
        )

        XCTAssertFalse(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.bgSurface)
    }

    func testTopBarStyleIsNonGlassWhenAccessibilityPrefersOpaque() {
        let spec = DSTopBar.styleSpec(
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass),
            capability: DSStyleCapabilitySnapshot(
                supportsGlassMaterial: true,
                accessibility: DSAccessibilitySnapshot(
                    reduceTransparencyEnabled: false,
                    increasedContrastEnabled: true
                )
            )
        )

        XCTAssertFalse(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.bgSurface)
    }
}
