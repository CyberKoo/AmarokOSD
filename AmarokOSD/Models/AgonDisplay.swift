import Foundation

struct AgonDisplay: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let location: String
    let vendorID: UInt32
    let modelID: UInt32
    let serialNumber: UInt32
}
