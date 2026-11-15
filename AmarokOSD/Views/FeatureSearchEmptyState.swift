import SwiftUI

struct FeatureSearchEmptyState: View {
    var body: some View {
        ContentUnavailableView.search
            .frame(maxWidth: .infinity, minHeight: 320)
    }
}
