import XCTest
@testable import DesignSystemForIOS

final class DSButtonStyleTests: XCTestCase {
    func testPrimaryMediumStyleSpec() {
        let spec = DSButton.styleSpec(
            variant: .primary,
            size: .medium,
            isEnabled: true
        )

        XCTAssertEqual(spec.background, DSSemanticColorTokens.accentPrimary)
        XCTAssertEqual(spec.foreground, DSSemanticColorTokens.textInverse)
        XCTAssertEqual(spec.height, DSDimensionTokens.d40)
        XCTAssertEqual(spec.typography, DSTypographyTokens.labelM)
    }

    func testDisabledStyleSpecUsesMutedPalette() {
        let spec = DSButton.styleSpec(
            variant: .danger,
            size: .large,
            isEnabled: false
        )

        XCTAssertEqual(spec.background, DSSemanticColorTokens.bgMuted)
        XCTAssertEqual(spec.foreground, DSSemanticColorTokens.textSecondary)
        XCTAssertEqual(spec.border, DSSemanticColorTokens.bgMuted)
    }

    func testSmallButtonUsesSmallMetrics() {
        let spec = DSButton.styleSpec(
            variant: .secondary,
            size: .small,
            isEnabled: true
        )

        XCTAssertEqual(spec.height, DSDimensionTokens.d32)
        XCTAssertEqual(spec.horizontalPadding, DSSpacingTokens.s12)
        XCTAssertEqual(spec.typography, DSTypographyTokens.labelS)
    }

    func testGlassPolicyAppliesForSecondaryButton() {
        let spec = DSButton.styleSpec(
            variant: .secondary,
            size: .medium,
            isEnabled: true,
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        )

        XCTAssertTrue(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.glassFill)
        XCTAssertEqual(spec.border, DSSemanticColorTokens.glassStroke)
    }

    func testGlassPolicyDoesNotOverridePrimaryButton() {
        let spec = DSButton.styleSpec(
            variant: .primary,
            size: .medium,
            isEnabled: true,
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        )

        XCTAssertFalse(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.accentPrimary)
    }

    func testGlassPolicyFallsBackToNonGlassWhenCapabilityDisablesGlass() {
        let spec = DSButton.styleSpec(
            variant: .secondary,
            size: .medium,
            isEnabled: true,
            policy: DSVisualStylePolicy(themeMode: .system, visualStyle: .glass),
            capability: DSStyleCapabilitySnapshot(
                supportsGlassMaterial: false,
                accessibility: DSAccessibilitySnapshot()
            )
        )

        XCTAssertFalse(spec.usesGlassMaterial)
        XCTAssertEqual(spec.background, DSSemanticColorTokens.bgSurface)
        XCTAssertEqual(spec.border, DSSemanticColorTokens.strokeSoft)
    }
}
