import SwiftUI

struct DisplayConnectionView: View {
    @ObservedObject var store: DisplayStore
    let onRefresh: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            if store.isRefreshing || !store.hasRefreshed {
                IconBadge(systemName: "display", size: 72)
                ProgressView()
                Text("正在查找支持 DDC/CI 的外接显示器…")
                    .foregroundStyle(.secondary)
            } else {
                ContentUnavailableView {
                    Label("未发现可控制的显示器", systemImage: "display.trianglebadge.exclamationmark")
                } description: {
                    Text("请确认外接显示器已连接并支持 DDC/CI，然后重新查找。")
                } actions: {
                    Button("重新查找", systemImage: "arrow.clockwise", action: onRefresh)
                        .liquidGlassButtonStyle(prominent: true)
                        .controlSize(.large)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.clear)
    }
}
