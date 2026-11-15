import SwiftUI

struct AppCommands: Commands {
    let model: AppModel
    let onAbout: () -> Void
    @ObservedObject var displays: DisplayStore

    init(model: AppModel, onAbout: @escaping () -> Void) {
        self.model = model
        self.onAbout = onAbout
        displays = model.displayStore
    }

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("关于 AmarokOSD", action: onAbout)
        }
        CommandGroup(after: .sidebar) {
            Button("刷新显示器", action: model.refreshDisplays)
                .keyboardShortcut("r", modifiers: .command)
                .disabled(displays.isRefreshing)
        }
    }
}
