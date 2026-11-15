import Foundation

struct AgonFeature: Identifiable, Hashable, Sendable {
    let name: String
    let address: String
    let namedValues: [AgonNamedValue]
    let supportPath: AgonSupportPath

    var id: String { name }
    var valueDomain: AgonValueDomain {
        supportPath == .notApplicable && namedValues.isEmpty ? .number : .named
    }
}
