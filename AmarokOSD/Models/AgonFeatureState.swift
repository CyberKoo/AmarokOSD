import Foundation

enum AgonFeatureState: Equatable, Sendable {
    case idle
    case loading
    case unsupported
    case ready(AgonValue)
    case failed(String)
}
