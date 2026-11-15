import SwiftUI

struct FeatureSearchEmptyState: View {
    var body: some View {
        WorkspaceStateContainer {
            ContentUnavailableView.search
        }
        .accessibilityIdentifier("search-empty-state")
    }
}
