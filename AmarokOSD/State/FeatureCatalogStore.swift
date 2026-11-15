import Foundation

@MainActor
final class FeatureCatalogStore: ObservableObject {
    let features: [AgonFeature]
    @Published var selectedName: String?
    @Published var selectedCategory = FeatureCategory.picture
    @Published var searchText = ""

    init(features: [AgonFeature]) {
        self.features = features
        selectedName = features.first?.name
    }

    var selectedFeature: AgonFeature? {
        features.first { $0.name == selectedName }
    }

    var hasSearchQuery: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var filteredFeatures: [AgonFeature] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return features }
        return features.filter {
            $0.title.localizedStandardContains(query)
                || $0.name.localizedStandardContains(query)
                || $0.address.localizedStandardContains(query)
        }
    }

    var populatedCategories: [FeatureCategory] {
        FeatureCategory.allCases.filter { category in
            features.contains { $0.category == category }
        }
    }

    func visibleCategories(using featureStates: FeatureStateStore) -> [FeatureCategory] {
        let visibleFeatures = featureStates.visibleFeatures(from: features)
        return populatedCategories.filter { category in
            visibleFeatures.contains { $0.category == category }
        }
    }

    func filteredFeatures(in category: FeatureCategory) -> [AgonFeature] {
        filteredFeatures.filter { $0.category == category }
    }
}
