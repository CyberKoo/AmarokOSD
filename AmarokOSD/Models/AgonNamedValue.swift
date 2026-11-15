import Foundation

struct AgonNamedValue: Identifiable, Hashable, Sendable {
    let name: String
    let value: UInt16

    var id: UInt16 { value }
}
