#if DEBUG
import Foundation

actor SimulatedAgonController: AgonControlling {
    private let displays = [
        AgonDisplay(
            id: "1",
            name: "Simulated Display",
            location: "IOService:/simulation/display-1",
            vendorID: 0x1234,
            modelID: 0x5678,
            serialNumber: 42
        )
    ]
    private let featureDefinitions: [String: AgonFeature]
    private var values: [String: AgonValue]

    init(features: [AgonFeature]) {
        featureDefinitions = Dictionary(uniqueKeysWithValues: features.map { ($0.name, $0) })
        values = SimulatedValueFactory.makeValues(for: features)
    }

    nonisolated func invalidateDisplayConnections() {}

    func refresh() async throws -> [AgonDisplay] {
        displays
    }

    func read(displayID: String, feature: String) async throws -> AgonValue {
        try value(displayID: displayID, feature: feature)
    }

    func set(displayID: String, feature: String, value: UInt16) async throws -> AgonValue {
        let current = try self.value(displayID: displayID, feature: feature)
        guard let definition = featureDefinitions[feature], definition.canWrite(value, for: current) else {
            throw AgonError(kind: .valueAboveMaximum, message: "仿真值超出范围或不在可选值中")
        }
        let readback = AgonValue(
            current: value,
            maximum: current.maximum,
            namedValues: current.namedValues,
            capabilities: current.capabilities
        )
        values[feature] = readback
        return readback
    }

    func probe(displayID: String, feature: String) async throws -> AgonProbe {
        AgonProbe(isSupported: true, value: try value(displayID: displayID, feature: feature))
    }

    private func value(displayID: String, feature: String) throws -> AgonValue {
        guard displays.contains(where: { $0.id == displayID }) else {
            throw AgonError(kind: .displayNotFound, message: "仿真显示器不存在")
        }
        guard let value = values[feature] else {
            throw AgonError(kind: .unsupportedFeature, message: "仿真功能不存在")
        }
        return value
    }
}
#endif
