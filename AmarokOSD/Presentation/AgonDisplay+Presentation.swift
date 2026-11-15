import Foundation

extension AgonDisplay {
    var vendorLabel: String {
        Self.hexLabel(vendorID)
    }

    var modelLabel: String {
        Self.hexLabel(modelID)
    }

    private static func hexLabel(_ value: UInt32) -> String {
        let hex = String(value, radix: 16).uppercased()
        return String(repeating: "0", count: max(0, 4 - hex.count)) + hex
    }
}
