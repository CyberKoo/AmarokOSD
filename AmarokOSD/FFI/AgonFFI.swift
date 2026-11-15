import Foundation

enum AgonFFI {
    static func check(
        _ status: UInt32,
        error: OpaquePointer?
    ) throws {
        defer { agon_error_destroy(error) }
        guard status == UInt32(AGON_OK) else {
            let message = error.flatMap { agon_error_message($0) }.map {
                String(cString: $0)
            } ?? "FFI 返回状态 \(status)"
            throw AgonError(status: status, message: message)
        }
    }

    static func string(from pointer: UnsafePointer<CChar>?) -> String {
        guard let pointer else { return "" }
        return String(validatingUTF8: pointer) ?? ""
    }
}
