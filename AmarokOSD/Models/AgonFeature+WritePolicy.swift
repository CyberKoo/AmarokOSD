import Foundation

extension AgonFeature {
    var requiresWriteConfirmation: Bool {
        switch name {
        case "input-source", "pixel-orbiting", "screen-saver", "multi-logo-protection",
             "thermal-protection", "auto-pixel-refresh":
            return true
        default:
            return false
        }
    }
}
