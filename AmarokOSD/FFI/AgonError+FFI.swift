import Foundation

extension AgonError {
    init(status: UInt32, message: String) {
        let kind: Kind = switch status {
        case UInt32(AGON_INVALID_ARGUMENT): .invalidArgument
        case UInt32(AGON_UNSUPPORTED_PLATFORM): .unsupportedPlatform
        case UInt32(AGON_DISPLAY_NOT_FOUND): .displayNotFound
        case UInt32(AGON_UNSUPPORTED_FEATURE): .unsupportedFeature
        case UInt32(AGON_VALUE_ABOVE_MAXIMUM): .valueAboveMaximum
        case UInt32(AGON_TRANSPORT_ERROR): .transport
        case UInt32(AGON_INVALID_RESPONSE): .invalidResponse
        case UInt32(AGON_WRITE_UNCERTAIN): .writeUncertain
        case UInt32(AGON_READBACK_FAILED): .readbackFailed
        case UInt32(AGON_INTERNAL_ERROR): .internal
        default: .unknown
        }
        self.init(
            kind: kind,
            message: kind == .unknown ? "\(message)（FFI 状态 \(status)）" : message
        )
    }
}
