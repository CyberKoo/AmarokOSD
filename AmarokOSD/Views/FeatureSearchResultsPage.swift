import SwiftUI

struct FeatureSearchResultsPage: View {
    let model: AppModel
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore

    init(model: AppModel) {
        self.model = model
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var features: [AgonFeature] {
        featureStates.visibleFeatures(from: catalog.filteredFeatures)
    }

    var body: some View {
        if features.isEmpty {
            FeatureSearchEmptyState()
        } else {
            FeatureMasterDetailView(
                model: model,
                title: "搜索结果",
                subtitle: "找到 \(features.count) 项功能",
                features: features
            )
        }
    }
}
