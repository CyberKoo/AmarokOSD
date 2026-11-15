import SwiftUI

struct WriteProgress: View {
    let isWriting: Bool

    var body: some View {
        if isWriting {
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                Text("正在应用并验证…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
