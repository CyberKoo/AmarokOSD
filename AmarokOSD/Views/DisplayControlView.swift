import SwiftUI

struct DisplayControlView: View {
    let model: AppModel
    let displays: DisplayStore
    @State private var headerLayout: FeatureWorkspaceHeaderLayout = .regular

    var body: some View {
        NavigationSplitView {
            DisplaySidebar(
                store: displays,
                onSelect: { id in model.selectDisplay(id) }
            )
            .navigationSplitViewColumnWidth(min: 210, ideal: 230, max: 280)
        } detail: {
            FeatureWorkspaceView(model: model)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
                .background(WidthReader { headerLayout.update(detailWidth: $0) })
        }
        .toolbar {
            AppToolbar(model: model, usesCompactHeader: headerLayout.usesCompactLayout)
        }
        .navigationTitle("")
        .toolbarTitleDisplayMode(.inline)
    }
}
