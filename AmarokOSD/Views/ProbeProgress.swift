import SwiftUI

struct ProbeProgress: View {
    @ObservedObject var store: FeatureStateStore
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("正在探测功能")
                    .font(.caption)
                Spacer()
                Text("\(store.completedProbes) / \(total)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: Double(store.completedProbes), total: Double(total))
                .tint(.accentColor)
        }
        .padding(13)
        .liquidGlass(cornerRadius: 16)
    }
}
