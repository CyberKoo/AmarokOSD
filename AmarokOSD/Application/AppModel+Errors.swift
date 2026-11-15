import Foundation

extension AppModel {
    static func makeError(_ error: Error) -> AgonError {
        (error as? AgonError) ?? AgonError(kind: .internal, message: error.localizedDescription)
    }

    func featureState(for error: Error) -> AgonFeatureState {
        let error = Self.makeError(error)
        if error.kind == .unsupportedFeature {
            return .unsupported
        }
        return .failed(error.message)
    }

    func show(_ error: Error) {
        alertStore.alert = AgonAlert(error: Self.makeError(error))
    }
}
