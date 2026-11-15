import Foundation

struct AgonValue: Equatable, Sendable {
    let current: UInt16
    let maximum: UInt16
    let namedValues: [AgonNamedValue]
    let capabilities: [UInt8]

    init(
        current: UInt16,
        maximum: UInt16,
        namedValues: [AgonNamedValue] = [],
        capabilities: [UInt8] = []
    ) {
        self.current = current
        self.maximum = maximum
        self.namedValues = namedValues
        self.capabilities = capabilities
    }
}
