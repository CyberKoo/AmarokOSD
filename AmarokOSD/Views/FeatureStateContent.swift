import SwiftUI

struct FeatureStateContent: View {
    let feature: AgonFeature
    let state: AgonFeatureState
    let isWriting: Bool
    let isReading: Bool
    let onRead: () -> Void
    let onWrite: (UInt16, Bool) -> Void

    var body: some View {
        switch state {
        case .idle:
            ContentUnavailableView(
                "尚未读取",
                systemImage: "arrow.down.circle",
                description: Text("点击重新读取获取当前值")
            )
            .frame(minHeight: 300)
        case .loading:
            FeatureLoadingState()
        case .unsupported:
            ContentUnavailableView(
                "当前显示器不支持此功能",
                systemImage: "minus.circle",
                description: Text("功能支持情况由显示器固件和连接方式决定")
            )
            .frame(minHeight: 300)
        case .failed(let message):
            FeatureFailureState(message: message, onRetry: onRead)
        case .ready(let value):
            FeatureValueEditor(
                feature: feature,
                value: value,
                isWriting: isWriting,
                isReading: isReading,
                onWrite: onWrite
            )
        }
    }
}
