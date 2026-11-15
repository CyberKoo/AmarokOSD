import SwiftUI

struct FeatureDetailContainer: View {
    let model: AppModel
    let feature: AgonFeature
    @ObservedObject var features: FeatureStateStore

    init(model: AppModel, feature: AgonFeature) {
        self.model = model
        self.feature = feature
        features = model.featureStore
    }

    var body: some View {
        FeatureDetailView(
            feature: feature,
            state: features.state(for: feature),
            isWriting: features.writingFeature == feature.name,
            isReading: features.readingFeature == feature.name,
            onRead: { model.read(feature) },
            onWrite: { model.set($0, for: feature, confirmed: $1) }
        )
        .onAppear {
            model.selectFeature(feature.name)
        }
    }
}
