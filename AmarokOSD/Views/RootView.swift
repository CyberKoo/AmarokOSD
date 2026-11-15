import AppKit
import Combine
import SwiftUI

struct RootView: View {
    let model: AppModel
    @ObservedObject var displays: DisplayStore
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore

    init(model: AppModel) {
        self.model = model
        displays = model.displayStore
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var showsAccents: Bool {
        !displays.displays.isEmpty && !featureStates.visibleFeatures(from: catalog.filteredFeatures).isEmpty
    }

    var body: some View {
        Group {
            if displays.displays.isEmpty {
                DisplayConnectionView(store: displays, onRefresh: model.refreshDisplays)
                    .background(AppBackground())
            } else {
                DisplayControlView(model: model, displays: displays, showsAccents: showsAccents)
            }
        }
        .background {
            AlertPresenter(store: model.alertStore)
        }
        #if DEBUG
        .environment(\._accessibilityReduceTransparency, AppFactory.isReduceTransparencyRequested)
        .preferredColorScheme(AppFactory.simulatedColorScheme)
        #endif
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

#Preview("无显示器") {
    RootView(model: AppFactory.makeSimulated(scenario: .noDisplays))
        .frame(width: 1280, height: 800)
}

#Preview("无支持功能") {
    RootView(model: AppFactory.makeSimulated(scenario: .noSupportedFeatures))
        .frame(width: 1280, height: 800)
}

#Preview("读取失败") {
    RootView(model: AppFactory.makeSimulated(scenario: .probeFailure))
        .frame(width: 1280, height: 800)
}

#Preview("浅色模式") {
    RootView(model: AppFactory.makeSimulated())
        .frame(width: 1280, height: 800)
        .preferredColorScheme(.light)
}

#Preview("减少透明度") {
    RootView(model: AppFactory.makeSimulated())
        .frame(width: 1280, height: 800)
        .environment(\._accessibilityReduceTransparency, true)
}
#endif
