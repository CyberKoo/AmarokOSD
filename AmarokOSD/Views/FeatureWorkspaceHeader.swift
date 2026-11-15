import SwiftUI

enum FeatureWorkspaceHeaderLayout {
    private static let compactDetailWidth = 870.0
    private static let regularDetailWidth = 890.0

    case regular
    case compact

    var usesCompactLayout: Bool {
        self == .compact
    }

    mutating func update(detailWidth: Double) {
        switch self {
        case .regular where detailWidth < Self.compactDetailWidth:
            self = .compact
        case .compact where detailWidth >= Self.regularDetailWidth:
            self = .regular
        default:
            break
        }
    }
}

struct FeatureWorkspaceHeader: View {
    let categories: [FeatureCategory]
    @Binding var selectedCategory: FeatureCategory
    @Binding var searchText: String
    /// Uses the compact layout in narrow windows to keep toolbar controls out of the overflow menu.
    let usesCompactLayout: Bool

    var body: some View {
        if usesCompactLayout {
            compactLayout
        } else {
            regularLayout
        }
    }

    private var regularLayout: some View {
        HStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                FeatureCategoryTabBar(categories: categories, selection: $selectedCategory)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            FeatureSearchField(text: $searchText)
                .frame(width: 200)
        }
    }

    private var compactLayout: some View {
        HStack(spacing: 10) {
            categoryMenu
            FeatureSearchField(text: $searchText)
                .frame(width: 170)
        }
    }

    private var categoryMenu: some View {
        Menu {
            ForEach(categories) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Label(category.title, systemImage: category.iconName)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: selectedCategory.iconName)
                Text(selectedCategory.title)
                    .font(.callout.weight(.medium))
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .liquidGlass(
                cornerRadius: 12,
                tint: Color.accentColor.opacity(0.10),
                interactive: true,
                fallback: AnyShapeStyle(.quaternary.opacity(0.5))
            )
            .fixedSize()
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
        .accessibilityLabel(Text("显示类别：\(selectedCategory.title)"))
    }
}
