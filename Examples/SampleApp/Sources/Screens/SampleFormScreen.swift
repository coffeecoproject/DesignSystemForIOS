import DesignSystemForIOS
import SwiftUI

struct SampleFormScreen: View {
    @State private var title = ""
    @State private var note = ""

    var body: some View {
        DesignSystem.Component.SheetScaffold(
            title: "Create Activity",
            subtitle: "Form Skeleton"
        ) {
            VStack(spacing: DesignSystem.Semantic.Spacing.stackRegular) {
                DesignSystem.Component.FormTextField(
                    title: "Title",
                    placeholder: "Input title",
                    text: $title
                )

                DesignSystem.Component.FormTextField(
                    title: "Note",
                    placeholder: "Input note",
                    text: $note
                )

                DesignSystem.Component.InlineLoadingView(
                    title: "Draft validation",
                    detail: "Running local checks..."
                )
            }
        } footer: {
            DesignSystem.Component.Button(
                title: "Submit",
                variant: .primary,
                size: .large
            ) {}
        }
    }
}
