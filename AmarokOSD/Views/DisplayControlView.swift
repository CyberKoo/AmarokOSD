import SwiftUI

struct DisplayControlView: View {
    let model: AppModel
    let displays: DisplayStore
    let showsAccents: Bool
    @State private var detailWidth: Double = 0

    var body: some View {
        NavigationSplitView {
            DisplaySidebar(
                store: displays,
                onSelect: { id in model.selectDisplay(id) },
                onRefresh: model.refreshDisplays
            )
            .navigationSplitViewColumnWidth(min: 210, ideal: 230, max: 280)
        } detail: {
            FeatureWorkspaceView(model: model)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppBackground(showsAccents: showsAccents))
                .background(WidthReader { detailWidth = $0 })
        }
        .toolbar {
            AppToolbar(model: model, detailWidth: detailWidth)
        }
        .navigationTitle("")
        .toolbarTitleDisplayMode(.inline)
    }
}
