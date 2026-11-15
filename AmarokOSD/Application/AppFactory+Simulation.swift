#if DEBUG
import SwiftUI

@MainActor
extension AppFactory {
    static var isSimulationRequested: Bool {
        ProcessInfo.processInfo.arguments.contains("-SimulatedUI")
    }

    static var isReduceTransparencyRequested: Bool {
        ProcessInfo.processInfo.arguments.contains("-SimulatedReduceTransparency")
    }

    static var simulatedColorScheme: ColorScheme? {
        if ProcessInfo.processInfo.arguments.contains("-SimulatedDarkAppearance") { return .dark }
        if ProcessInfo.processInfo.arguments.contains("-SimulatedLightAppearance") { return .light }
        return nil
    }

    static func makeSimulated(scenario: SimulatedAgonScenario = .current) -> AppModel {
        let features = SimulatedValueFactory.makeFeatures()
        return AppModel(
            client: SimulatedAgonController(features: features, scenario: scenario),
            features: features,
            initializationError: nil,
            makeClient: { SimulatedAgonController(features: features, scenario: scenario) }
        )
    }
}
#endif
