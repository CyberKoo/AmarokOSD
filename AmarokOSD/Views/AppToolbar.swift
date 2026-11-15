import SwiftUI

struct AppToolbar: ToolbarContent {
    let model: AppModel
    @ObservedObject var displays: DisplayStore
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore
    let usesCompactHeader: Bool

    init(model: AppModel, usesCompactHeader: Bool) {
        self.usesCompactHeader = usesCompactHeader
        self.model = model
        displays = model.displayStore
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var populatedCategories: [FeatureCategory] {
        catalog.visibleCategories(using: featureStates)
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            FeatureWorkspaceHeader(
                categories: populatedCategories,
                selectedCategory: $catalog.selectedCategory,
                searchText: $catalog.searchText,
                usesCompactLayout: usesCompactHeader
            )
            .frame(maxWidth: .infinity)
        }
        ToolbarItemGroup(placement: .primaryAction) {
            if featureStates.isProbing {
                Button("取消探测", systemImage: "stop.circle", action: model.cancelProbe)
            } else {
                Button("探测全部", systemImage: "wand.and.rays", action: model.probeAllFeatures)
                    .disabled(displays.selectedDisplay == nil || displays.isRefreshing)
            }
            Button("刷新", systemImage: "arrow.clockwise", action: model.refreshDisplays)
                .disabled(displays.isRefreshing)
        }
    }
}
