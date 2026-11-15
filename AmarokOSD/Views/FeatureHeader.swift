import SwiftUI

struct FeatureHeader: View {
    let feature: AgonFeature
    let state: AgonFeatureState
    let isWriting: Bool
    let isReading: Bool
    let onRead: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Label(feature.title, systemImage: feature.iconName)
                    .font(.title.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                HStack(spacing: 8) {
                    Text(feature.name)
                    Text("·")
                    Text("DDC \(feature.address)")
                }
                .font(.callout)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            }
            .layoutPriority(1)
            Spacer(minLength: 12)
            Button(action: onRead) {
                if isReading {
                    ProgressView()
                        .controlSize(.small)
                        .frame(minWidth: 72)
                } else {
                    Label("重新读取", systemImage: "arrow.clockwise")
                }
            }
            .liquidGlassButtonStyle()
            .controlSize(.large)
            .disabled(state == .loading || isWriting || isReading)
            .fixedSize()
            .accessibilityIdentifier("feature-read")
        }
    }
}
