import SwiftUI

struct FeatureWorkspaceView: View {
    let model: AppModel
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore

    init(model: AppModel) {
        self.model = model
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var populatedCategories: [FeatureCategory] {
        catalog.visibleCategories(using: featureStates)
    }

    var body: some View {
        VStack(spacing: 0) {
            if populatedCategories.isEmpty {
                if featureStates.isProbing || featureStates.states.isEmpty {
                    FeatureLoadingState()
                        .padding(AppTheme.pagePadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView(
                        "没有支持的功能",
                        systemImage: "display",
                        description: Text("当前显示器没有可调整的功能")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else if catalog.hasSearchQuery {
                FeatureSearchResultsPage(model: model)
            } else {
                FeatureCategoryPage(model: model, category: catalog.selectedCategory)
            }
        }
        .background(.clear)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if featureStates.isProbing {
                ProbeProgress(store: featureStates, total: catalog.features.count)
                    .padding(14)
            }
        }
        .onChange(of: populatedCategories) { _, categories in
            if !categories.contains(catalog.selectedCategory), let first = categories.first {
                catalog.selectedCategory = first
            }
        }
    }
}
