#if DEBUG
import Foundation

enum SimulatedValueFactory {
    static func makeFeatures() -> [AgonFeature] {
        [
            AgonFeature(name: "brightness", address: "0x10", namedValues: [], supportPath: .notApplicable),
            AgonFeature(name: "contrast", address: "0x12", namedValues: [], supportPath: .notApplicable),
            AgonFeature(name: "game-mode", address: "0x20", namedValues: values("standard", "fps", "rts", "racing"), supportPath: .notApplicable),
            AgonFeature(name: "adaptive-sync", address: "0x21", namedValues: [], supportPath: .notApplicable),
            AgonFeature(name: "race-assist", address: "0x22", namedValues: values("off", "on"), supportPath: .notApplicable),
            AgonFeature(name: "color-gamut", address: "0x30", namedValues: values("srgb", "adobe-rgb", "dci-p3"), supportPath: .maximum),
            AgonFeature(name: "saturation-red", address: "0x31", namedValues: [], supportPath: .notApplicable),
            AgonFeature(name: "gamma", address: "0x32", namedValues: values("gamma1", "gamma2", "gamma3", "gamma4", "gamma5"), supportPath: .capabilityList),
            AgonFeature(name: "input-source", address: "0x40", namedValues: values("vga", "hdmi1", "hdmi2", "dp1", "dp2", "usb-c1"), supportPath: .notApplicable),
            AgonFeature(name: "volume", address: "0x41", namedValues: [], supportPath: .notApplicable),
            AgonFeature(name: "light-fx-mode", address: "0x50", namedValues: values("off", "breathing", "rainbow"), supportPath: .notApplicable),
            AgonFeature(name: "pixel-orbiting", address: "0x60", namedValues: values("off", "on"), supportPath: .notApplicable)
        ]
    }

    static func makeValues(for features: [AgonFeature]) -> [String: AgonValue] {
        Dictionary(uniqueKeysWithValues: features.map { feature in
            let current: UInt16 = switch feature.name {
            case "brightness": 25
            case "contrast", "saturation-red": 50
            case "volume": 30
            case "gamma": 2
            default: feature.namedValues.first?.value ?? 0
            }
            let maximum = feature.valueDomain == .number
                ? (feature.name == "adaptive-sync" ? 1 : 100)
                : feature.namedValues.map(\.value).max() ?? 0
            let namedValues = feature.valueDomain == .named ? feature.namedValues : []
            let capabilities = feature.supportPath == .capabilityList
                ? namedValues.compactMap { UInt8(exactly: $0.value) }
                : []
            return (
                feature.name,
                AgonValue(
                    current: current,
                    maximum: maximum,
                    namedValues: namedValues,
                    capabilities: capabilities
                )
            )
        })
    }

    private static func values(_ names: String...) -> [AgonNamedValue] {
        names.enumerated().map { AgonNamedValue(name: $0.element, value: UInt16($0.offset)) }
    }
}
#endif
