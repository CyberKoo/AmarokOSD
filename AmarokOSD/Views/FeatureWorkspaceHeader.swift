import AppKit
import SwiftUI

/// Fits the category strip and the search control into the toolbar header.
///
/// The header is a toolbar principal item, so it is rendered at its ideal
/// width: asking for more room than the toolbar allocated makes the whole
/// item disappear into the titlebar overflow menu. The layout therefore has
/// to be resolved from the measured width before the view is built.
struct FeatureWorkspaceHeaderLayout: Equatable {
    /// Spacing between category content areas, included in each segment.
    static let tabSpacing = 5.0
    /// Base horizontal padding on each side of a category button.
    static let categoryHorizontalInset = 12.0
    /// Additional horizontal width around the category strip (4 on each side).
    static let tabStripPadding = 8.0
    static let tabStripHeight = 40.0

    static func categoryLeadingInset(isFirst: Bool) -> Double {
        categoryHorizontalInset + (isFirst ? tabStripPadding / 2 : tabSpacing / 2)
    }

    static func categoryTrailingInset(isLast: Bool) -> Double {
        categoryHorizontalInset + (isLast ? tabStripPadding / 2 : tabSpacing / 2)
    }

    /// The "…" button plus the spacing that separates it from the tabs.
    static let overflowMenuWidth = 40.0
    /// Width of the "…" button itself.
    static let overflowMenuButtonWidth = 28.0
    static let compactSpacing = 12.0
    static let searchFieldWidth = 200.0
    static let searchButtonWidth = 40.0
    static let contentSpacing = 20.0
    /// Fallback used until a category has been measured.
    static let unmeasuredCategoryWidth = 88.0

    let visibleCount: Int
    let showsSearchField: Bool
    let isCompact: Bool

    static func resolve(
        availableWidth: Double,
        categories: [FeatureCategory],
        widths: [FeatureCategory: Double]
    ) -> FeatureWorkspaceHeaderLayout {
        guard !categories.isEmpty else {
            return FeatureWorkspaceHeaderLayout(visibleCount: 0, showsSearchField: false, isCompact: false)
        }

        // The width is not known until the first layout pass; keep every
        // category visible for that frame instead of collapsing the strip.
        guard availableWidth > 0 else {
            return FeatureWorkspaceHeaderLayout(
                visibleCount: categories.count,
                showsSearchField: false,
                isCompact: false
            )
        }

        func width(of category: FeatureCategory) -> Double {
            widths[category] ?? unmeasuredCategoryWidth
        }

        func tabStripWidth(for count: Int) -> Double {
            guard count > 0 else { return 0 }
            let content = categories.prefix(count).reduce(0.0) { $0 + width(of: $1) }
            return content + tabSpacing * Double(count - 1) + tabStripPadding
        }

        let allTabsWidth = tabStripWidth(for: categories.count)

        if allTabsWidth + contentSpacing + searchFieldWidth <= availableWidth {
            return FeatureWorkspaceHeaderLayout(
                visibleCount: categories.count,
                showsSearchField: true,
                isCompact: false
            )
        }

        if allTabsWidth + contentSpacing + searchButtonWidth <= availableWidth {
            return FeatureWorkspaceHeaderLayout(
                visibleCount: categories.count,
                showsSearchField: false,
                isCompact: false
            )
        }

        let tabBudget = availableWidth - contentSpacing - searchButtonWidth - overflowMenuWidth
        var fittingCount = 0
        for count in 1...categories.count where tabStripWidth(for: count) <= tabBudget {
            fittingCount = count
        }

        if fittingCount > 0 {
            return FeatureWorkspaceHeaderLayout(
                visibleCount: fittingCount,
                showsSearchField: false,
                isCompact: false
            )
        }

        return FeatureWorkspaceHeaderLayout(visibleCount: 0, showsSearchField: false, isCompact: true)
    }
}

struct FeatureWorkspaceHeader: View {
    /// Space the titlebar reserves on both sides of the principal item,
    /// measured on macOS 26: a header wider than `windowWidth - 460` is
    /// moved into the toolbar overflow menu. With the detail column at
    /// `windowWidth - 230`, that leaves `detailWidth - 230` usable.
    private static let toolbarChromeWidth = 230.0
    /// Keeps rounding differences from pushing the header over the limit.
    private static let fitSafetyMargin = 8.0
    /// Room reserved for the "关闭" button next to the expanded search field.
    private static let searchCloseButtonReserve = 84.0

    let categories: [FeatureCategory]
    @Binding var selectedCategory: FeatureCategory
    @Binding var searchText: String
    let onSelectCategory: (FeatureCategory) -> Void
    let detailWidth: Double
    @State private var isSearchExpanded = false
    @State private var categoryWidths: [FeatureCategory: Double]

    init(
        categories: [FeatureCategory],
        selectedCategory: Binding<FeatureCategory>,
        searchText: Binding<String>,
        onSelectCategory: @escaping (FeatureCategory) -> Void,
        detailWidth: Double
    ) {
        self.categories = categories
        _selectedCategory = selectedCategory
        _searchText = searchText
        self.onSelectCategory = onSelectCategory
        self.detailWidth = detailWidth
        _categoryWidths = State(initialValue: Self.measureWidths(for: categories))
    }

    private static func measureWidths(for categories: [FeatureCategory]) -> [FeatureCategory: Double] {
        let font = NSFont.preferredFont(forTextStyle: .callout)
        return Dictionary(uniqueKeysWithValues: categories.map { category in
            let textWidth = (category.title as NSString).size(withAttributes: [.font: font]).width
            return (category, textWidth + FeatureWorkspaceHeaderLayout.categoryHorizontalInset * 2)
        })
    }

    private var availableWidth: Double {
        max(0, detailWidth - Self.toolbarChromeWidth - Self.fitSafetyMargin)
    }

    private var layout: FeatureWorkspaceHeaderLayout {
        FeatureWorkspaceHeaderLayout.resolve(
            availableWidth: availableWidth,
            categories: categories,
            widths: categoryWidths
        )
    }

    private var visibleCategories: [FeatureCategory] {
        Array(categories.prefix(layout.visibleCount))
    }

    private var hiddenCategories: [FeatureCategory] {
        Array(categories.dropFirst(layout.visibleCount))
    }

    var body: some View {
        content
            .onAppear(perform: measureCategories)
            .onChange(of: categories) { _, _ in measureCategories() }
            .onChange(of: layout.showsSearchField) { _, showsSearchField in
                if showsSearchField {
                    isSearchExpanded = false
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if isSearchExpanded && !layout.showsSearchField {
            expandedSearchLayout
        } else if layout.isCompact {
            compactLayout
        } else {
            tabLayout
        }
    }

    private var tabLayout: some View {
        HStack(spacing: FeatureWorkspaceHeaderLayout.contentSpacing) {
            tabStrip
            if layout.showsSearchField {
                FeatureSearchField(text: $searchText)
                    .frame(width: FeatureWorkspaceHeaderLayout.searchFieldWidth)
            } else {
                compactSearchButton
            }
        }
    }

    private var tabStrip: some View {
        HStack(spacing: FeatureWorkspaceHeaderLayout.tabSpacing) {
            FeatureCategoryTabBar(
                categories: visibleCategories,
                selection: $selectedCategory,
                onSelect: selectCategory
            )
            .fixedSize(horizontal: true, vertical: false)
            if !hiddenCategories.isEmpty {
                moreMenu(categories: hiddenCategories)
            }
        }
        .frame(height: FeatureWorkspaceHeaderLayout.tabStripHeight)
        .clipShape(Capsule())
        .liquidGlass(cornerRadius: 20, fallback: AnyShapeStyle(.quaternary.opacity(0.5)))
    }

    private var compactLayout: some View {
        HStack(spacing: FeatureWorkspaceHeaderLayout.compactSpacing) {
            moreMenu(categories: categories)
                .frame(height: 40)
                .liquidGlass(
                    cornerRadius: 20,
                    interactive: true,
                    fallback: AnyShapeStyle(.quaternary.opacity(0.5))
                )
            compactSearchButton
        }
    }

    private var expandedSearchLayout: some View {
        HStack(spacing: FeatureWorkspaceHeaderLayout.compactSpacing) {
            FeatureSearchField(text: $searchText)
                .frame(maxWidth: min(320, max(120, availableWidth - Self.searchCloseButtonReserve)))
            Button("关闭") {
                isSearchExpanded = false
            }
            .liquidGlassButtonStyle()
            .accessibilityIdentifier("feature-search-close")
        }
    }

    private var compactSearchButton: some View {
        Button {
            isSearchExpanded = true
        } label: {
            Image(systemName: "magnifyingglass")
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .liquidGlass(
                    cornerRadius: 20,
                    tint: searchText.isEmpty ? nil : AppTheme.selectionTint,
                    interactive: true,
                    fallback: AnyShapeStyle(.quaternary.opacity(0.5))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("搜索功能")
        .accessibilityIdentifier("feature-search-button")
        .help(searchText.isEmpty ? "搜索功能" : "编辑当前搜索")
    }

    private func moreMenu(categories: [FeatureCategory]) -> some View {
        Menu {
            ForEach(categories) { category in
                Button {
                    selectCategory(category)
                } label: {
                    Label(category.title, systemImage: category.iconName)
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.callout.weight(.medium))
                .frame(width: FeatureWorkspaceHeaderLayout.overflowMenuButtonWidth, height: 32)
                .contentShape(.rect(cornerRadius: 12))
        }
        .menuIndicator(.hidden)
        .menuStyle(.borderlessButton)
        .fixedSize()
        .accessibilityLabel("更多分类")
        .accessibilityIdentifier("category-more")
    }

    private func selectCategory(_ category: FeatureCategory) {
        isSearchExpanded = false
        onSelectCategory(category)
    }

    private func measureCategories() {
        let widths = Self.measureWidths(for: categories)
        guard widths != categoryWidths else { return }
        categoryWidths = widths
    }
}
