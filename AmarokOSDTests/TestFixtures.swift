import Foundation
@testable import AmarokOSD

enum TestFixtures {
    static let displayID = "1"

    static func feature(
        name: String = "brightness",
        address: String = "0x10",
        namedValues: [AgonNamedValue] = [],
        supportPath: AgonSupportPath = .notApplicable
    ) -> AgonFeature {
        AgonFeature(
            name: name,
            address: address,
            namedValues: namedValues,
            supportPath: supportPath
        )
    }

    static func value(
        current: UInt16 = 25,
        maximum: UInt16 = 100,
        namedValues: [AgonNamedValue] = [],
        capabilities: [UInt8] = []
    ) -> AgonValue {
        AgonValue(
            current: current,
            maximum: maximum,
            namedValues: namedValues,
            capabilities: capabilities
        )
    }
}
