import Foundation

extension AgonClient {
    func read(displayID: String, feature: String) async throws -> AgonValue {
        try await perform {
            var value = agon_value_t()
            var error: OpaquePointer?
            let status = displayID.withCString { displayID in
                feature.withCString { feature in
                    agon_read(self.session.pointer, displayID, feature, &value, &error)
                }
            }
            try AgonFFI.check(status, error: error)
            return try Self.value(
                forFeatureNamed: feature,
                from: value,
                displayID: displayID,
                session: self.session
            )
        }
    }
}
