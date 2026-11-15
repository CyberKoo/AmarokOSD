import Foundation

extension AppModel {
    func cancelOperations() {
        refreshTask?.cancel()
        refreshTask = nil
        readTask?.cancel()
        readTask = nil
        probeTask?.cancel()
        probeTask = nil
        writeTask?.cancel()
        writeTask = nil
        featureStore.cancelOperations()
    }
}
