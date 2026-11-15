import Foundation

extension AgonClient {
    func set(displayID: String, feature: String, value: UInt16) async throws -> AgonValue {
        try await perform {
            var readback = agon_value_t()
            var error: OpaquePointer?
            let status = displayID.withCString { displayID in
                feature.withCString { feature in
                    agon_set(self.session.pointer, displayID, feature, value, &readback, &error)
                }
            }
            try AgonFFI.check(status, error: error)
            return try Self.value(
                forFeatureNamed: feature,
                from: readback,
                displayID: displayID,
                session: self.session
            )
        }
    }
}
