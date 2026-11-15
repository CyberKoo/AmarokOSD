import Foundation

extension AgonFeature {
    func numericMaximum(for value: AgonValue) -> UInt16? {
        valueDomain == .number ? value.maximum : nil
    }

    func availableNamedValues(for value: AgonValue) -> [AgonNamedValue]? {
        guard valueDomain == .named else { return nil }
        switch supportPath {
        case .capabilityList:
            var seen = Set<UInt16>()
            return value.capabilities.compactMap { capability in
                let rawValue = UInt16(capability)
                guard seen.insert(rawValue).inserted else { return nil }
                return namedValues.first(where: { $0.value == rawValue })
                    ?? AgonNamedValue(name: "\(capability)", value: rawValue)
            }
        case .maximum:
            return value.namedValues
        case .notApplicable:
            return namedValues
        }
    }

    func hasAdjustableValues(for value: AgonValue) -> Bool {
        if let maximum = numericMaximum(for: value) {
            return maximum > 0
        }
        return availableNamedValues(for: value)?.isEmpty == false
    }

    func canWrite(_ newValue: UInt16, for current: AgonValue) -> Bool {
        if let maximum = numericMaximum(for: current) {
            return maximum > 0 && newValue <= maximum
        }
        return availableNamedValues(for: current)?.contains(where: { $0.value == newValue }) == true
    }
}
