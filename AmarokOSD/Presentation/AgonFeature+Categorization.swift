import Foundation

extension AgonFeature {
    var category: FeatureCategory {
        switch name {
        case "brightness", "contrast", "sharpness", "color-preset", "display-scaling",
             "hdr-mode", "dcb-mode", "eco-mode", "low-blue-mode", "shadow-control",
             "local-dimming", "shadow-boost", "adaptive-sync", "auto-warning", "lea",
             "clear-sight", "life-glow", "auto-vision":
            return .picture
        case "input-source", "volume", "mute", "audio-output", "daisy-chain":
            return .inputAndAudio
        case "game-mode", "gamma", "overdrive", "low-input-lag", "dial-point",
             "frame-counter", "sharp-shooter-size", "race-assist", "spotlight", "night-sight":
            return .gaming
        case "saturation-red", "saturation-yellow", "saturation-green", "saturation-cyan",
             "saturation-blue", "saturation-magenta", "hue-red", "hue-yellow", "hue-green",
             "hue-cyan", "hue-blue", "hue-magenta", "color-gamut":
            return .color
        case "light-fx", "light-fx-mode":
            return .lighting
        case "pixel-orbiting", "screen-saver", "multi-logo-protection", "boundary-dimmer",
             "taskbar-dimmer", "thermal-protection", "auto-pixel-refresh":
            return .panelCare
        default:
            return .other
        }
    }
}
