import SwiftUI

struct FeatureCategoryPage: View {
    let model: AppModel
    let category: FeatureCategory
    @ObservedObject var featureStates: FeatureStateStore

    init(model: AppModel, category: FeatureCategory) {
        self.model = model
        self.category = category
        featureStates = model.featureStore
    }

    private var features: [AgonFeature] {
        featureStates.visibleFeatures(from: model.catalogStore.filteredFeatures(in: category))
    }

    var body: some View {
        FeatureMasterDetailView(
            model: model,
            title: category.title,
            subtitle: category.subtitle,
            features: features
        )
    }
}
