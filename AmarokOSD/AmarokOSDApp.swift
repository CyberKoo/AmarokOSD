import SwiftUI

@main
struct AmarokOSDApp: App {
    @StateObject private var model = AppFactory.make()

    var body: some Scene {
        WindowGroup("AmarokOSD") {
            RootView(model: model)
                .frame(minWidth: 960, minHeight: 640)
        }
        .windowToolbarStyle(.unified)
        .commands {
            AppCommands(model: model, onAbout: AboutWindowController.shared.show)
        }
    }
}
