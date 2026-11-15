import SwiftUI

@main
struct AmarokOSDApp: App {
    @StateObject private var model = AppFactory.make()

    var body: some Scene {
        WindowGroup("AmarokOSD") {
            RootView(model: model)
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowToolbarStyle(.unified)
        .commands {
            AppCommands(model: model, onAbout: AboutWindowController.shared.show)
        }
    }
}
