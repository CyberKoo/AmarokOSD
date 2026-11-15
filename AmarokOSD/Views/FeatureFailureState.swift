import SwiftUI

struct FeatureFailureState: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        CardContainer {
            VStack(spacing: 15) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text("读取失败")
                    .font(.title2.bold())
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
                Button("重试", systemImage: "arrow.clockwise", action: onRetry)
                    .liquidGlassButtonStyle(prominent: true)
                    .controlSize(.large)
            }
            .frame(maxWidth: .infinity, minHeight: 220)
        }
    }
}
