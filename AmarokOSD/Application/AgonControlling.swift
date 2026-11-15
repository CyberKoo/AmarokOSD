import Foundation

protocol AgonControlling: Sendable {
    func invalidateDisplayConnections()
    func refresh() async throws -> [AgonDisplay]
    func read(displayID: String, feature: String) async throws -> AgonValue
    func set(displayID: String, feature: String, value: UInt16) async throws -> AgonValue
    func probe(displayID: String, feature: String) async throws -> AgonProbe
}
