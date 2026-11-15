import SwiftUI

struct FeatureSearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            TextField("搜索全部功能或地址", text: $text)
                .textFieldStyle(.plain)
            if !text.isEmpty {
                Button("清除搜索", systemImage: "xmark.circle.fill") {
                    text = ""
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .liquidGlass(cornerRadius: 14, fallback: AnyShapeStyle(.quaternary.opacity(0.5)))
        .frame(maxWidth: 360)
    }
}
