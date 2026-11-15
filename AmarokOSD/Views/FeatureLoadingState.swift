import SwiftUI

struct FeatureLoadingState: View {
    var body: some View {
        CardContainer {
            VStack(spacing: 14) {
                ProgressView()
                    .controlSize(.large)
                Text("正在与显示器通信…")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 220)
        }
    }
}
