import DesignSystemForIOS
import SwiftUI

struct SampleAppRootView: View {
    var body: some View {
        SampleHomeScreen()
            .dsRuntimeSurfaceCapabilityBridge()
            .dsVisualStylePolicy(
                .init(
                    themeMode: .system,
                    visualStyle: .glass
                )
            )
            .dsAccessibilityPolicy(
                .init(
                    dynamicTypePolicy: .clamped(min: .small, max: .accessibility3),
                    minimumHitTarget: 44,
                    voiceOverHintsEnabled: true
                )
            )
    }
}
