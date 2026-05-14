import DesignSystemForIOS
import SwiftUI

struct SampleHomeScreen: View {
    var body: some View {
        DesignSystem.Primitive.Container {
            DesignSystem.Component.TopBar(
                title: "Activities",
                subtitle: "Sample Structure",
                trailingActions: [
                    .init(
                        systemImage: "plus",
                        accessibilityLabel: "Create Activity",
                        action: {}
                    )
                ]
            )

            DesignSystem.Component.ListRow(
                title: "Morning Coffee",
                subtitle: "Pending confirmation",
                accessory: .badge("NEW")
            )

            DesignSystem.Component.ListRow(
                title: "Workout",
                subtitle: "Starts at 07:00",
                accessory: .disclosure
            )

            DesignSystem.Component.ToastBanner(
                message: "Sample feedback area is ready.",
                kind: .info
            )
        }
    }
}
