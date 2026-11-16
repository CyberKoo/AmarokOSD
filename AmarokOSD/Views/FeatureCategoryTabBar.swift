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
        HStack(spacing: 0) {
            ForEach(categories) { category in
                categoryButton(for: category)
            }
        }
    }

    @ViewBuilder
    private func categoryButton(for category: FeatureCategory) -> some View {
        let isFirst = category == categories.first
        let isLast = category == categories.last
        let shape = UnevenRoundedRectangle(
            topLeadingRadius: isFirst ? 20 : 12,
            bottomLeadingRadius: isFirst ? 20 : 12,
            bottomTrailingRadius: isLast ? 20 : 12,
            topTrailingRadius: isLast ? 20 : 12,
            style: .continuous
        )
        let button = Button(category.title) {
            select(category)
        }
        .font(.callout)
        .foregroundStyle(selection == category ? Color.primary : .secondary)
        .padding(.leading, FeatureWorkspaceHeaderLayout.categoryLeadingInset(isFirst: isFirst))
        .padding(.trailing, FeatureWorkspaceHeaderLayout.categoryTrailingInset(isLast: isLast))
        .frame(height: FeatureWorkspaceHeaderLayout.tabStripHeight)
        .contentShape(shape)
        .buttonStyle(.plain)
        .accessibilityAddTraits(selection == category ? .isSelected : [])
        .accessibilityIdentifier("category-\(category.rawValue)")

        Group {
            if #available(macOS 26.0, *), selection == category, !reduceTransparency {
                button
                    .glassEffect(
                        .regular.tint(AppTheme.subtleSelectionTint).interactive(),
                        in: shape
                    )
            } else {
                button
                    .background(
                        selection == category ? AppTheme.cardBackground : .clear,
                        in: shape
                    )
                    .background(
                        selection == category ? AppTheme.subtleSelectionTint : .clear,
                        in: shape
                    )
            }
        }
    }

    private func select(_ category: FeatureCategory) {
        selection = category
        onSelect(category)
    }
}
