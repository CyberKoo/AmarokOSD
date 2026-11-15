#if DEBUG
import Foundation

@MainActor
extension AppFactory {
    static var isSimulationRequested: Bool {
        ProcessInfo.processInfo.arguments.contains("-SimulatedUI")
    }

    static func makeSimulated() -> AppModel {
        let features = SimulatedValueFactory.makeFeatures()
        return AppModel(
            client: SimulatedAgonController(features: features),
            features: features,
            initializationError: nil,
            makeClient: { SimulatedAgonController(features: features) }
        )
    }
}
#endif
