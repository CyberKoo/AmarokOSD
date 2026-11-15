import Foundation

extension AgonClient {
    func refresh() async throws -> [AgonDisplay] {
        try await perform(reconnecting: false) {
            var list: OpaquePointer?
            var error: OpaquePointer?
            let status = agon_session_refresh(self.session.pointer, &list, &error)
            try AgonFFI.check(status, error: error)
            guard let list else {
                throw AgonError(status: UInt32(AGON_INTERNAL_ERROR), message: "FFI 未返回显示器列表")
            }
            defer { agon_display_list_destroy(list) }
            return try Self.displays(from: list)
        }
    }

    private static func displays(
        from list: OpaquePointer
    ) throws -> [AgonDisplay] {
        try (0..<agon_display_list_count(list)).map { index in
            var info = agon_display_info_t()
            let status = agon_display_list_get(list, index, &info)
            guard status == UInt32(AGON_OK) else {
                throw AgonError(status: status, message: "无法读取显示器信息")
            }
            return AgonDisplay(
                id: AgonFFI.string(from: info.id),
                name: AgonFFI.string(from: info.name),
                location: AgonFFI.string(from: info.location),
                vendorID: info.vendor_id,
                modelID: info.model_id,
                serialNumber: info.serial_number
            )
        }
    }
}
