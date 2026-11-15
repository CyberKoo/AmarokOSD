import Foundation

struct AgonError: Error, LocalizedError, Sendable {
    enum Kind: Equatable, Sendable {
        case invalidArgument
        case unsupportedPlatform
        case displayNotFound
        case unsupportedFeature
        case valueAboveMaximum
        case transport
        case invalidResponse
        case writeUncertain
        case readbackFailed
        case `internal`
        case unknown
    }

    let kind: Kind
    let message: String

    var errorDescription: String? { message }
}
