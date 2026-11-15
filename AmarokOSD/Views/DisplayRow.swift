import SwiftUI

struct DisplayRow: View {
    let display: AgonDisplay
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 11) {
                Image(systemName: "display")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                    .frame(width: 40, height: 40)
                    .background(
                        Color.accentColor.opacity(isSelected ? 0.10 : 0.05),
                        in: .rect(cornerRadius: 12)
                    )
                    .accessibilityHidden(true)
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
                tint: isSelected ? AppTheme.selectionTint : nil,
                interactive: true,
                fallback: AnyShapeStyle(isHovering ? Color.primary.opacity(0.05) : .clear)
            )
            .contentShape(.rect(cornerRadius: AppTheme.rowRadius))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(display.name))
        .help(display.name)
        .onHover { isHovering = $0 }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
