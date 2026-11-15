import SwiftUI

struct WriteProgress: View {
    let isWriting: Bool

    var body: some View {
        if isWriting {
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                Text("正在写入并回读…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
