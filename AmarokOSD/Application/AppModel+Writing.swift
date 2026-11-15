import Foundation

extension AppModel {
    func set(_ value: UInt16, for feature: AgonFeature, confirmed: Bool) {
        guard let client, let displayID = displayStore.selectedID else { return }
        guard !feature.requiresWriteConfirmation || confirmed else {
            alertStore.alert = AgonAlert(
                title: "需要确认修改",
                message: "此操作可能中断当前画面或启动面板维护流程，请确认后再继续。"
            )
            return
        }
        if case .ready(let current)? = featureStore.states[feature.name], !feature.canWrite(value, for: current) {
            if let maximum = feature.numericMaximum(for: current), value > maximum {
                alertStore.alert = AgonAlert(title: "数值超出范围", message: "最大值为 \(maximum)。")
            } else {
                alertStore.alert = AgonAlert(title: "数值无效", message: "该值不在当前显示器的可选值中。")
            }
            return
        }

        writeTask?.cancel()
        writeTask = nil
        guard featureStore.beginWrite(for: feature) else { return }
        writeTask = Task {
            do {
                let readback = try await client.set(displayID: displayID, feature: feature.name, value: value)
                guard !Task.isCancelled, displayStore.selectedID == displayID else { return }
                featureStore.finishWrite(readback, for: feature, displayID: displayID)
            } catch {
                guard !Task.isCancelled else { return }
                featureStore.failWrite(for: feature)
                show(error)
            }
        }
    }
}
