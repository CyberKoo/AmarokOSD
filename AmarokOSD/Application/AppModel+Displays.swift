import Foundation

extension AppModel {
    func invalidateDisplayConnections() {
        client?.invalidateDisplayConnections()
    }

    func refreshDisplays() {
        updateDisplays(probingFeatures: false)
    }

    func loadDisplays() {
        updateDisplays(probingFeatures: true)
    }

    private func updateDisplays(probingFeatures: Bool) {
        guard let client, !displayStore.isRefreshing else { return }
        cancelOperations()
        displayStore.isRefreshing = true

        refreshTask = Task {
            do {
                let result = try await client.refresh()
                guard !Task.isCancelled else { return }
                let previousID = displayStore.selectedID
                displayStore.displays = result
                if !result.contains(where: { $0.id == displayStore.selectedID }) {
                    displayStore.selectedID = result.first?.id
                }
                if displayStore.selectedID != previousID {
                    featureStore.reset()
                    if let selectedID = displayStore.selectedID {
                        _ = featureStore.restoreCachedProbe(for: selectedID)
                    }
                }
                displayStore.hasRefreshed = true
                displayStore.isRefreshing = false
                if probingFeatures {
                    probeAllFeatures()
                }
            } catch {
                guard !Task.isCancelled else { return }
                displayStore.hasRefreshed = true
                displayStore.isRefreshing = false
                show(error)
            }
        }
    }

    func selectDisplay(_ id: String?) {
        guard displayStore.selectedID != id else { return }
        displayStore.selectedID = id
        cancelOperations()
        featureStore.reset()
        if let id, featureStore.restoreCachedProbe(for: id) { return }
        probeAllFeatures()
    }
}
