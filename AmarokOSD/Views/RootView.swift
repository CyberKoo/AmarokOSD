import AppKit
import Combine
import SwiftUI

struct RootView: View {
    let model: AppModel
    @ObservedObject var displays: DisplayStore

    init(model: AppModel) {
        self.model = model
        displays = model.displayStore
    }

    var body: some View {
        Group {
            if displays.displays.isEmpty {
                DisplayConnectionView(store: displays, onRefresh: model.refreshDisplays)
            } else {
                DisplayControlView(model: model, displays: displays)
            }
        }
        .background(AppBackground())
        .background {
            AlertPresenter(store: model.alertStore)
        }
        .onAppear(perform: model.start)
        .onReceive(
            NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
                .merge(with: NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.screensDidWakeNotification))
        ) { _ in
            model.invalidateDisplayConnections()
        }
    }
}

#if DEBUG
#Preview("仿真主界面") {
    RootView(model: AppFactory.makeSimulated())
        .frame(width: 1280, height: 800)
}
#endif
