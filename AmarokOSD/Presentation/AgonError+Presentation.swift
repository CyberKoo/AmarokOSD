import Foundation

extension AgonError {
    var title: String {
        switch kind {
        case .invalidArgument: "参数无效"
        case .unsupportedPlatform: "当前平台不支持"
        case .displayNotFound: "找不到显示器"
        case .unsupportedFeature: "功能不受支持"
        case .valueAboveMaximum: "数值超出范围"
        case .transport: "显示器通信失败"
        case .invalidResponse: "显示器响应无效"
        case .writeUncertain: "写入结果不确定"
        case .readbackFailed: "写入后回读失败"
        case .internal, .unknown: "操作失败"
        }
    }

    var alertMessage: String {
        switch kind {
        case .writeUncertain, .readbackFailed:
            message + "\n\n设置可能已经生效，请先读取当前值，不要直接重复写入。"
        default:
            message
        }
    }
}
