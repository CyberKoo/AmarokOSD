import Foundation

extension AgonNamedValue {
    var label: String {
        NamedValueLocalization.title(for: name)
    }
}
