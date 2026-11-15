import SwiftUI

struct FeatureCategoryTabBar: View {
    let categories: [FeatureCategory]
    @Binding var selection: FeatureCategory
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        buttons
            .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: selection)
    }

    private var buttons: some View {
        HStack(spacing: 5) {
            ForEach(categories) { category in
                categoryButton(for: category)
            }
        }
    }

    @ViewBuilder
    private func categoryButton(for category: FeatureCategory) -> some View {
        let button = Button(category.title) {
            select(category)
        }
        .font(.callout)
        .foregroundStyle(selection == category ? Color.primary : .secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .contentShape(.rect(cornerRadius: 12))
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == category ? .isSelected : [])

        if #available(macOS 26.0, *), selection == category, !reduceTransparency {
            button
                .glassEffect(
                    .regular.tint(Color.accentColor.opacity(0.10)).interactive(),
                    in: .rect(cornerRadius: 12)
                )
        } else {
            button
                .background(
                    selection == category ? Color.accentColor.opacity(0.13) : .clear,
                    in: .rect(cornerRadius: 12)
                )
        }
    }

    private func select(_ category: FeatureCategory) {
        guard selection != category else { return }
        selection = category
    }
}
