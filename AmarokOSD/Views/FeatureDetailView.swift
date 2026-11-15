import SwiftUI

struct FeatureDetailView: View {
    let feature: AgonFeature
    let state: AgonFeatureState
    let isWriting: Bool
    let isReading: Bool
    let onRead: () -> Void
    let onWrite: (UInt16, Bool) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                FeatureHeader(
                    feature: feature,
                    state: state,
                    isWriting: isWriting,
                    isReading: isReading,
                    onRead: onRead
                )
                FeatureStateContent(
                    feature: feature,
                    state: state,
                    isWriting: isWriting,
                    isReading: isReading,
                    onRead: onRead,
                    onWrite: onWrite
                )
            }
            .padding(AppTheme.pagePadding)
            .frame(maxWidth: 760, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .scrollContentBackground(.visible)
    }
}
