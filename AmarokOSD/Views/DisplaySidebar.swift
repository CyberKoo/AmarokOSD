import SwiftUI

struct DisplaySidebar: View {
    @ObservedObject var store: DisplayStore
    let onSelect: @MainActor @Sendable (String?) -> Void

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

            DisplayDiscoveryStatus(store: store)

            if let display = store.selectedDisplay {
                DisplayDetails(display: display)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
