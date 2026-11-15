import Foundation

extension AppModel {
    func selectFeature(_ name: String?) {
        guard catalogStore.selectedName != name else { return }
        readTask?.cancel()
        readTask = nil
        featureStore.cancelRead()
        catalogStore.selectedName = name
    }

    func read(_ feature: AgonFeature) {
        guard let client, let displayID = displayStore.selectedID else { return }
        readTask?.cancel()
        readTask = nil
        let previousValue = featureStore.beginRead(for: feature)
        readTask = Task {
            do {
                let value = try await client.read(displayID: displayID, feature: feature.name)
                guard isCurrent(displayID: displayID, feature: feature), !Task.isCancelled else { return }
                featureStore.finishRead(value, for: feature, displayID: displayID)
            } catch {
                guard isCurrent(displayID: displayID, feature: feature), !Task.isCancelled else { return }
                featureStore.failRead(
                    for: feature,
                    displayID: displayID,
                    previousValue: previousValue,
                    failure: featureState(for: error)
                )
                if previousValue != nil {
                    show(error)
                }
            }
        }
    }

    private func isCurrent(displayID: String, feature: AgonFeature) -> Bool {
        displayStore.selectedID == displayID && catalogStore.selectedFeature == feature
    }
}
