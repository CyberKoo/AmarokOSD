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
            CardContainer {
                ContentUnavailableView(
                    "尚未读取",
                    systemImage: "arrow.down.circle",
                    description: Text("点击重新读取获取当前值")
                )
                .frame(maxWidth: .infinity, minHeight: 220)
            }
        case .loading:
            FeatureLoadingState()
        case .unsupported:
            CardContainer {
                ContentUnavailableView(
                    "当前显示器不支持此功能",
                    systemImage: "minus.circle",
                    description: Text("功能支持情况由显示器固件和连接方式决定")
                )
                .frame(maxWidth: .infinity, minHeight: 220)
            }
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
