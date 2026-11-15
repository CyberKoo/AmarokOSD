import SwiftUI

struct DisplayDiscoveryStatus: View {
    @ObservedObject var store: DisplayStore

    var body: some View {
        if store.isRefreshing {
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                Text("正在刷新显示器…")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .liquidGlass(cornerRadius: 22, fallback: AnyShapeStyle(.quaternary))
            .accessibilityIdentifier("display-discovery-status")
        }
    }
}
