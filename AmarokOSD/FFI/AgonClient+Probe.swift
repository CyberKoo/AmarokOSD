import Foundation

extension AgonClient {
    func probe(displayID: String, feature: String) async throws -> AgonProbe {
        try await perform {
            var supported: UInt8 = 0
            var value = agon_value_t()
            var error: OpaquePointer?
            let status = displayID.withCString { displayID in
                feature.withCString { feature in
                    agon_probe(self.session.pointer, displayID, feature, &supported, &value, &error)
                }
            }
            try AgonFFI.check(status, error: error)
            let probedValue = supported == 0 ? nil : try Self.value(
                forFeatureNamed: feature,
                from: value,
                displayID: displayID,
                session: self.session
            )
            return AgonProbe(
                isSupported: supported != 0,
                value: probedValue
            )
        }
    }
}
