import SwiftUI

struct WorkspaceStateContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        CardContainer {
            content
                .frame(maxWidth: .infinity, minHeight: 220)
        }
        .padding(AppTheme.pagePadding)
        .frame(maxWidth: 760)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier("workspace-state")
    }
}
