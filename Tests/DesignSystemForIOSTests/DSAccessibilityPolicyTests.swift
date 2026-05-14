import XCTest
@testable import DesignSystemForIOS

final class DSAccessibilityPolicyTests: XCTestCase {
    func testMinimumHitTargetHasLowerBound() {
        let policy = DSAccessibilityPolicy(
            dynamicTypePolicy: .system,
            minimumHitTarget: 12,
            voiceOverHintsEnabled: true
        )

        XCTAssertEqual(policy.minimumHitTarget, DSDimensionTokens.d32)
    }

    func testPolicyStoresDynamicTypeAndVoiceOverFlags() {
        let policy = DSAccessibilityPolicy(
            dynamicTypePolicy: .clamped(min: .small, max: .accessibility3),
            minimumHitTarget: 50,
            voiceOverHintsEnabled: false
        )

        XCTAssertEqual(policy.minimumHitTarget, 50)
        XCTAssertFalse(policy.voiceOverHintsEnabled)
        XCTAssertEqual(
            policy.dynamicTypePolicy,
            .clamped(min: .small, max: .accessibility3)
        )
    }
}
