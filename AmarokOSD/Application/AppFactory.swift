import Foundation

@MainActor
enum AppFactory {
    static func make() -> AppModel {
        #if DEBUG
        if isSimulationRequested {
            return makeSimulated()
        }
        #endif

        var features: [AgonFeature] = []
        var initializationError: AgonError?

        do {
            features = try AgonFeatureRepository().loadFeatures()
        } catch {
            initializationError = AppModel.makeError(error)
        }

        return AppModel(
            client: nil,
            features: features,
            initializationError: initializationError,
            makeClient: { try await AgonClient.create() }
        )
    }
}
