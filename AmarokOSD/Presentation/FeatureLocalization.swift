import Foundation

enum FeatureLocalization {
    static func title(for name: String) -> String {
        titles[name] ?? name.replacingOccurrences(of: "-", with: " ").capitalized
    }

    private static let titles = [
        "brightness": "亮度", "contrast": "对比度", "sharpness": "锐度",
        "color-preset": "色彩预设", "input-source": "输入源", "display-scaling": "显示缩放",
        "volume": "音量", "mute": "静音", "game-mode": "游戏模式", "gamma": "Gamma",
        "overdrive": "OverDrive", "hdr-mode": "HDR 模式", "dcb-mode": "DCB 模式",
        "eco-mode": "节能模式", "low-blue-mode": "低蓝光模式", "low-input-lag": "低输入延迟",
        "shadow-control": "暗部控制", "light-fx": "灯效亮度", "light-fx-mode": "灯效模式",
        "dial-point": "准星", "frame-counter": "帧计数器",
        "saturation-red": "红色饱和度", "saturation-yellow": "黄色饱和度",
        "saturation-green": "绿色饱和度", "saturation-cyan": "青色饱和度",
        "saturation-blue": "蓝色饱和度", "saturation-magenta": "品红饱和度",
        "hue-red": "红色色相", "hue-yellow": "黄色色相", "hue-green": "绿色色相",
        "hue-cyan": "青色色相", "hue-blue": "蓝色色相", "hue-magenta": "品红色相",
        "color-gamut": "色域", "local-dimming": "局部调光", "shadow-boost": "Shadow Boost",
        "sharp-shooter-size": "狙击镜尺寸", "pixel-orbiting": "像素偏移",
        "screen-saver": "屏保", "multi-logo-protection": "多徽标保护",
        "boundary-dimmer": "边界变暗", "taskbar-dimmer": "任务栏变暗",
        "adaptive-sync": "Adaptive Sync", "auto-warning": "自动警告", "lea": "LEA",
        "thermal-protection": "热保护", "auto-pixel-refresh": "自动像素刷新",
        "race-assist": "Race Assist", "spotlight": "SpotLight", "night-sight": "NightSight",
        "clear-sight": "ClearSight", "life-glow": "LifeGlow", "auto-vision": "AutoVision",
        "audio-output": "音频输出", "daisy-chain": "Daisy Chain"
    ]
}
