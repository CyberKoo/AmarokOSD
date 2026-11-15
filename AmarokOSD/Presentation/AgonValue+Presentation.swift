import Foundation

extension AgonValue {
    func displayText(for feature: AgonFeature) -> String {
        let metadataNamedValues = namedValues.isEmpty ? feature.namedValues : namedValues
        if feature.valueDomain == .named,
           let named = metadataNamedValues.first(where: { $0.value == current }) {
            return named.label
        }
        if feature.valueDomain == .number && maximum == 1 {
            switch current {
            case 0: return "关闭"
            case 1: return "开启"
            default: break
            }
        }
        return "\(current)"
    }
}
