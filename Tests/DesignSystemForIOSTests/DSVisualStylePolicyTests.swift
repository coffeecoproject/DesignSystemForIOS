import SwiftUI
import XCTest
@testable import DesignSystemForIOS

final class DSVisualStylePolicyTests: XCTestCase {
    func testResolveColorSchemeInSystemMode() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .nonGlass)
        XCTAssertEqual(policy.resolveColorScheme(system: .light), .light)
        XCTAssertEqual(policy.resolveColorScheme(system: .dark), .dark)
    }

    func testResolveColorSchemeInForcedModes() {
        let lightPolicy = DSVisualStylePolicy(themeMode: .light, visualStyle: .nonGlass)
        let darkPolicy = DSVisualStylePolicy(themeMode: .dark, visualStyle: .glass)

        XCTAssertEqual(lightPolicy.resolveColorScheme(system: .dark), .light)
        XCTAssertEqual(darkPolicy.resolveColorScheme(system: .light), .dark)
    }

    func testResolveVisualStyleFallsBackWhenGlassMaterialUnsupported() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        let capability = DSStyleCapabilitySnapshot(
            supportsGlassMaterial: false,
            accessibility: DSAccessibilitySnapshot()
        )

        XCTAssertEqual(policy.resolveVisualStyle(capability: capability), .nonGlass)
    }

    func testResolveVisualStyleFallsBackWhenAccessibilityPrefersOpaqueSurface() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        let capability = DSStyleCapabilitySnapshot(
            supportsGlassMaterial: true,
            accessibility: DSAccessibilitySnapshot(
                reduceTransparencyEnabled: true,
                increasedContrastEnabled: false
            )
        )

        XCTAssertEqual(policy.resolveVisualStyle(capability: capability), .nonGlass)
    }

    func testResolveVisualStyleUsesContextOverride() {
        let policy = DSVisualStylePolicy(themeMode: .system, visualStyle: .glass)
        let capability = DSStyleCapabilitySnapshot(
            supportsGlassMaterial: true,
            accessibility: DSAccessibilitySnapshot()
        )

        XCTAssertEqual(
            policy.resolveVisualStyle(
                capability: capability,
                context: DSVisualStyleResolutionContext(prefersOpaqueSurface: true)
            ),
            .nonGlass
        )
    }
}
