import Foundation

enum FeatureCategory: String, CaseIterable, Identifiable, Sendable {
    case picture, gaming, color, inputAndAudio, lighting, panelCare, other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .picture: "画面"
        case .gaming: "游戏"
        case .color: "色彩"
        case .inputAndAudio: "输入与音频"
        case .lighting: "灯效"
        case .panelCare: "面板维护"
        case .other: "其他"
        }
    }

    var subtitle: String {
        switch self {
        case .picture: "亮度、图像模式与显示效果"
        case .gaming: "游戏辅助、响应速度与画面增强"
        case .color: "色域、六轴色相与饱和度"
        case .inputAndAudio: "视频输入、音量与音频输出"
        case .lighting: "显示器灯效与亮度"
        case .panelCare: "像素刷新与面板保护"
        case .other: "其他显示器设置"
        }
    }

    var iconName: String {
        switch self {
        case .picture: "photo"
        case .gaming: "gamecontroller"
        case .color: "paintpalette"
        case .inputAndAudio: "cable.connector"
        case .lighting: "lightbulb"
        case .panelCare: "shield"
        case .other: "gearshape"
        }
    }
}
