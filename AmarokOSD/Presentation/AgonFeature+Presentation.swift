import Foundation

extension AgonFeature {
    var title: String {
        FeatureLocalization.title(for: name)
    }

    var iconName: String {
        switch name {
        case "brightness": "sun.max.fill"
        case "contrast": "circle.lefthalf.filled"
        case "sharpness": "sparkles"
        case "color-preset": "paintpalette.fill"
        case "input-source": "cable.connector"
        case "display-scaling": "aspectratio"
        case "volume": "speaker.wave.2.fill"
        case "mute": "speaker.slash.fill"
        case "game-mode": "gamecontroller.fill"
        case "gamma": "chart.line.uptrend.xyaxis"
        case "overdrive": "speedometer"
        case "hdr-mode": "sun.horizon.fill"
        case "dcb-mode": "wand.and.stars"
        case "eco-mode": "leaf.fill"
        case "low-blue-mode": "moon.stars.fill"
        case "low-input-lag": "bolt.fill"
        case "shadow-control": "circle.bottomhalf.filled"
        case "light-fx": "lightbulb.fill"
        case "light-fx-mode": "lightbulb"
        case "dial-point": "scope"
        case "frame-counter": "timer"
        case "saturation-red", "saturation-yellow", "saturation-green", "saturation-cyan",
             "saturation-blue", "saturation-magenta": "drop.fill"
        case "hue-red", "hue-yellow", "hue-green", "hue-cyan", "hue-blue", "hue-magenta":
            "paintbrush.fill"
        case "color-gamut": "paintpalette"
        case "local-dimming": "square.grid.3x3.fill"
        case "shadow-boost": "sunrise.fill"
        case "sharp-shooter-size": "viewfinder"
        case "pixel-orbiting": "arrow.triangle.2.circlepath"
        case "screen-saver": "rectangle.on.rectangle"
        case "multi-logo-protection": "shield.fill"
        case "boundary-dimmer": "rectangle.dashed"
        case "taskbar-dimmer": "dock.rectangle"
        case "adaptive-sync": "arrow.triangle.2.circlepath"
        case "auto-warning": "exclamationmark.triangle.fill"
        case "lea": "eye.fill"
        case "thermal-protection": "thermometer.medium"
        case "auto-pixel-refresh": "arrow.clockwise"
        case "race-assist": "flag.checkered"
        case "spotlight": "light.max"
        case "night-sight": "moon.stars"
        case "clear-sight": "eye"
        case "life-glow": "heart.fill"
        case "auto-vision": "eye.circle"
        case "audio-output": "headphones"
        case "daisy-chain": "link"
        default: category.iconName
        }
    }
}
