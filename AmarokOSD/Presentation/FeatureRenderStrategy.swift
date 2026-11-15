import Foundation

enum FeatureRenderStrategy: Equatable {
    case number(maximum: UInt16)
    case capabilityList([AgonNamedValue])
    case maximum([AgonNamedValue])
    case staticNamed([AgonNamedValue])

    var numericMaximum: UInt16? {
        if case .number(let maximum) = self { return maximum }
        return nil
    }

}

extension AgonFeature {
    func renderStrategy(for value: AgonValue) -> FeatureRenderStrategy {
        if let maximum = numericMaximum(for: value) {
            return .number(maximum: maximum)
        }

        let values = availableNamedValues(for: value) ?? []
        switch supportPath {
        case .capabilityList:
            return .capabilityList(values)
        case .maximum:
            return .maximum(values)
        case .notApplicable:
            return .staticNamed(values)
        }
    }
}
