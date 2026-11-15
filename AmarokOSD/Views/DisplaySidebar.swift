import SwiftUI

struct DisplaySidebar: View {
    @ObservedObject var store: DisplayStore
    let onSelect: @MainActor @Sendable (String?) -> Void
    let onRefresh: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("显示器")
                    .font(.title3.bold())
                Spacer()
                Text("\(store.displays.count)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .liquidGlass(cornerRadius: 10, fallback: AnyShapeStyle(.quaternary))
                Button("刷新显示器", systemImage: "arrow.clockwise", action: onRefresh)
                    .labelStyle(.iconOnly)
                    .liquidGlassButtonStyle()
                    .controlSize(.small)
                    .disabled(store.isRefreshing)
                    .help("刷新显示器")
                    .accessibilityIdentifier("display-refresh")
            }
            .padding(.horizontal, 6)

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(store.displays) { display in
                        DisplayRow(
                            display: display,
                            isSelected: store.selectedID == display.id,
                            action: { onSelect(display.id) }
                        )
                    }
                }
            }
            .overlay(alignment: .bottom) {
                DisplayDiscoveryStatus(store: store)
                    .padding(8)
                    .transition(.opacity)
                    .allowsHitTesting(false)
            }
            .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: store.isRefreshing)

            if let display = store.selectedDisplay {
                DisplayDetails(display: display)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Group {
                if reduceTransparency {
                    AppTheme.pageBackground
                } else {
                    SidebarGlassBackground()
                }
            }
            .ignoresSafeArea()
        }
    }
}
