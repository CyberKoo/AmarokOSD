import SwiftUI

struct AppToolbar: ToolbarContent {
    let model: AppModel
    @ObservedObject var displays: DisplayStore
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore
    let detailWidth: Double

    init(model: AppModel, detailWidth: Double) {
        self.detailWidth = detailWidth
        self.model = model
        displays = model.displayStore
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var populatedCategories: [FeatureCategory] {
        catalog.visibleCategories(using: featureStates)
    }

    private var searchText: Binding<String> {
        Binding(
            get: { catalog.searchText },
            set: { catalog.updateSearchText($0) }
        )
    }

    private var featureWorkspaceHeader: some View {
        FeatureWorkspaceHeader(
            categories: populatedCategories,
            selectedCategory: $catalog.selectedCategory,
            searchText: searchText,
            onSelectCategory: catalog.selectCategory,
            detailWidth: detailWidth
        )
    }

    var body: some ToolbarContent {
        if !populatedCategories.isEmpty {
            if #available(macOS 26.1, *) {
                ToolbarItem(placement: .principal) {
                    featureWorkspaceHeader
                }
                .sharedBackgroundVisibility(.hidden)
                .visibilityPriority(.high)
            } else {
                ToolbarItem(placement: .principal) {
                    featureWorkspaceHeader
                }
            }
        }
        if #available(macOS 26.1, *) {
            ToolbarItemGroup(placement: .primaryAction) {
                if featureStates.isProbing {
                    Button("取消探测", systemImage: "stop.circle", action: model.cancelProbe)
                } else {
                    Button("探测全部", systemImage: "wand.and.rays", action: model.probeAllFeatures)
                        .disabled(displays.selectedDisplay == nil || displays.isRefreshing)
                }
            }
            .visibilityPriority(.low)
        } else {
            ToolbarItemGroup(placement: .primaryAction) {
                if featureStates.isProbing {
                    Button("取消探测", systemImage: "stop.circle", action: model.cancelProbe)
                } else {
                    Button("探测全部", systemImage: "wand.and.rays", action: model.probeAllFeatures)
                        .disabled(displays.selectedDisplay == nil || displays.isRefreshing)
                }
            }
        }
    }
}
