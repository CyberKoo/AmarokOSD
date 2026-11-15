import Foundation

extension AppModel {
    func start() {
        guard !didStart else { return }
        didStart = true
        if let initializationError {
            alertStore.alert = AgonAlert(error: initializationError)
            return
        }
        if client != nil {
            loadDisplays()
            return
        }

        Task {
            do {
                client = try await makeClient()
                loadDisplays()
            } catch {
                initializationError = Self.makeError(error)
                show(error)
            }
        }
    }
}
