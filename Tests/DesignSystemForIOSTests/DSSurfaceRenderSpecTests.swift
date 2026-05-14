import SwiftUI
import XCTest
@testable import DesignSystemForIOS

final class DSSurfaceRenderSpecTests: XCTestCase {
    func testNonGlassSurfaceSpecUsesSemanticSurfaceTokens() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .nonGlass)
        let spec = DSSurface<EmptyView>.renderSpec(
            style: .surface,
            policy: policy,
            baseShadow: DSShadowTokens.none
        )

        XCTAssertEqual(spec.fillToken, DSSemanticColorTokens.bgSurface)
        XCTAssertEqual(spec.strokeToken, DSSemanticColorTokens.strokeSoft)
        XCTAssertEqual(spec.shadowColorToken, DSSemanticColorTokens.textPrimary)
        XCTAssertFalse(spec.usesGlassMaterial)
    }

    func testGlassSurfaceSpecUsesGlassTokensAndDefaultCardShadow() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        let spec = DSSurface<EmptyView>.renderSpec(
            style: .accent,
            policy: policy,
            baseShadow: DSShadowTokens.none
        )

        XCTAssertEqual(spec.fillToken, DSSemanticColorTokens.glassFill)
        XCTAssertEqual(spec.strokeToken, DSSemanticColorTokens.glassStroke)
        XCTAssertEqual(spec.shadowColorToken, DSSemanticColorTokens.glassShadow)
        XCTAssertEqual(spec.shadow, DSShadowTokens.card)
        XCTAssertTrue(spec.usesGlassMaterial)
    }

    func testGlassSurfaceSpecFallsBackWhenAccessibilityPrefersOpaque() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        let spec = DSSurface<EmptyView>.renderSpec(
            style: .surface,
            policy: policy,
            capability: DSStyleCapabilitySnapshot(
                supportsGlassMaterial: true,
                accessibility: DSAccessibilitySnapshot(
                    reduceTransparencyEnabled: false,
                    increasedContrastEnabled: true
                )
            ),
            baseShadow: DSShadowTokens.none
        )

        XCTAssertEqual(spec.fillToken, DSSemanticColorTokens.bgSurface)
        XCTAssertEqual(spec.strokeToken, DSSemanticColorTokens.strokeSoft)
        XCTAssertFalse(spec.usesGlassMaterial)
    }
}
