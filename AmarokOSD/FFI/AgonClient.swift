import Foundation

final class AgonClient: AgonControlling, @unchecked Sendable {
    private static let initializationQueue = DispatchQueue(
        label: "app.amarok-osd.client.initialization",
        qos: .default
    )
    private let queue = DispatchQueue(label: "app.amarok-osd.client", qos: .default)
    private var displayConnectionsNeedRefresh = false
    let session: AgonSessionHandle

    static func create() async throws -> AgonClient {
        try await withCheckedThrowingContinuation { continuation in
            initializationQueue.async {
                continuation.resume(with: Result { try AgonClient() })
            }
        }
    }

    private init() throws {
        guard agon_abi_version() == UInt32(AGON_ABI_VERSION) else {
            throw AgonError(status: UInt32(AGON_INTERNAL_ERROR), message: "FFI ABI 版本不兼容")
        }

        var session: OpaquePointer?
        var error: OpaquePointer?
        let status = agon_session_create(&session, &error)
        try AgonFFI.check(status, error: error)
        guard let session else {
            throw AgonError(status: UInt32(AGON_INTERNAL_ERROR), message: "FFI 未返回会话")
        }
        self.session = AgonSessionHandle(pointer: session)
    }

    deinit {
        let session = self.session
        queue.async {
            agon_session_destroy(session.pointer)
        }
    }

    func invalidateDisplayConnections() {
        queue.async {
            self.displayConnectionsNeedRefresh = true
        }
    }

    func perform<T: Sendable>(
        reconnecting: Bool = true,
        _ operation: @escaping @Sendable () throws -> T
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            queue.async {
                continuation.resume(with: Result {
                    if reconnecting {
                        try self.refreshDisplayConnectionsIfNeeded()
                    }
                    let value = try operation()
                    self.displayConnectionsNeedRefresh = false
                    return value
                })
            }
        }
    }

    private func refreshDisplayConnectionsIfNeeded() throws {
        guard displayConnectionsNeedRefresh else { return }
        var list: OpaquePointer?
        var error: OpaquePointer?
        let status = agon_session_refresh(self.session.pointer, &list, &error)
        defer { agon_display_list_destroy(list) }
        try AgonFFI.check(status, error: error)
        displayConnectionsNeedRefresh = false
    }
}
