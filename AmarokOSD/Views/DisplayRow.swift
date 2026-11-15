import SwiftUI

struct DisplayRow: View {
    let display: AgonDisplay
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 11) {
                IconBadge(systemName: "display", size: 40, showsBackground: true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(display.name)
                        .font(.callout.weight(.medium))
                        .lineLimit(1)
                    Text("ID \(display.id)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundStyle(.tint)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass(
                cornerRadius: AppTheme.rowRadius,
                tint: isSelected ? Color.accentColor.opacity(0.16) : nil,
                interactive: true,
                fallback: AnyShapeStyle(isHovering ? Color.primary.opacity(0.05) : .clear)
            )
            .contentShape(.rect(cornerRadius: AppTheme.rowRadius))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(display.name))
        .onHover { isHovering = $0 }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
