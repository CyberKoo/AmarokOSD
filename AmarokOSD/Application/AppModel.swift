import Foundation

@MainActor
final class AppModel: ObservableObject {
    var client: AgonControlling?
    var initializationError: AgonError?
    let makeClient: () async throws -> AgonControlling
    let displayStore = DisplayStore()
    let catalogStore: FeatureCatalogStore
    let featureStore = FeatureStateStore()
    let alertStore = AlertStore()

    var refreshTask: Task<Void, Never>?
    var readTask: Task<Void, Never>?
    var probeTask: Task<Void, Never>?
    var writeTask: Task<Void, Never>?
    var didStart = false

    init(
        client: AgonControlling?,
        features: [AgonFeature],
        initializationError: AgonError?,
        makeClient: @escaping () async throws -> AgonControlling
    ) {
        self.client = client
        self.initializationError = initializationError
        self.makeClient = makeClient
        catalogStore = FeatureCatalogStore(features: features)
    }
}
