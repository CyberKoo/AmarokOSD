import SwiftUI

struct FeatureCategoryTabBar: View {
    let categories: [FeatureCategory]
    @Binding var selection: FeatureCategory
    let onSelect: (FeatureCategory) -> Void
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        buttons
            .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: selection)
    }

    private var buttons: some View {
        HStack(spacing: FeatureWorkspaceHeaderLayout.tabSpacing) {
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
        .padding(.horizontal, FeatureWorkspaceHeaderLayout.categoryHorizontalInset)
        .padding(.vertical, 8)
        .contentShape(.rect(cornerRadius: 12))
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == category ? .isSelected : [])
        .accessibilityIdentifier("category-\(category.rawValue)")

        Group {
            if #available(macOS 26.0, *), selection == category, !reduceTransparency {
                button
                    .glassEffect(
                        .regular.tint(AppTheme.subtleSelectionTint).interactive(),
                        in: .rect(cornerRadius: 12)
                    )
            } else {
                button
                    .background(
                        selection == category ? AppTheme.cardBackground : .clear,
                        in: .rect(cornerRadius: 12)
                    )
                    .background(
                        selection == category ? AppTheme.subtleSelectionTint : .clear,
                        in: .rect(cornerRadius: 12)
                    )
            }
        }
    }

    private func select(_ category: FeatureCategory) {
        selection = category
        onSelect(category)
    }
}
