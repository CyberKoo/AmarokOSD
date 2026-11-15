import Foundation

extension AppModel {
    func probeAllFeatures() {
        guard let client, let displayID = displayStore.selectedID, !featureStore.isProbing else { return }
        readTask?.cancel()
        readTask = nil
        featureStore.cancelRead()
        probeTask?.cancel()
        probeTask = nil
        let features = catalogStore.features
        featureStore.beginProbe(features: features)

        probeTask = Task {
            for (index, feature) in features.enumerated() {
                guard canContinue(displayID: displayID) else { return }
                do {
                    let result = try await client.probe(displayID: displayID, feature: feature.name)
                    guard canContinue(displayID: displayID) else { return }
                    let state: AgonFeatureState = if result.isSupported, let value = result.value {
                        .ready(value)
                    } else {
                        .unsupported
                    }
                    featureStore.recordProbe(state, for: feature, completed: index + 1)
                } catch {
                    guard canContinue(displayID: displayID) else { return }
                    featureStore.recordProbe(featureState(for: error), for: feature, completed: index + 1)
                }
            }
            featureStore.finishProbe(for: displayID)
        }
    }

    func cancelProbe() {
        probeTask?.cancel()
        probeTask = nil
        featureStore.cancelProbe()
    }

    private func canContinue(displayID: String) -> Bool {
        !Task.isCancelled && displayStore.selectedID == displayID
    }
}
