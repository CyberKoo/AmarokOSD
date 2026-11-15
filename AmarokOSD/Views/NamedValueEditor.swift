import SwiftUI

struct NamedValueEditor: View {
    let namedValues: [AgonNamedValue]
    @Binding var selection: UInt16
    let current: UInt16
    let isWriting: Bool
    let emptyMessage: LocalizedStringKey
    var sourceNote: LocalizedStringKey? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if namedValues.isEmpty {
                Label(emptyMessage, systemImage: "info.circle")
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 138), spacing: 10)], spacing: 10) {
                    ForEach(namedValues) { named in
                        OptionChip(
                            title: named.label,
                            subtitle: "值 \(named.value)",
                            isSelected: selection == named.value,
                            action: { selection = named.value }
                        )
                        .disabled(isWriting)
                    }
                }
            }
            if let sourceNote {
                Label(sourceNote, systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if !namedValues.isEmpty && !namedValues.contains(where: { $0.value == current }) {
                Label("当前值 \(current) 不在已知命名值中，可重新读取确认。", systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
