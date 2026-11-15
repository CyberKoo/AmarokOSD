import SwiftUI

struct FeatureWorkspaceView: View {
    let model: AppModel
    @ObservedObject var catalog: FeatureCatalogStore
    @ObservedObject var featureStates: FeatureStateStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(model: AppModel) {
        self.model = model
        catalog = model.catalogStore
        featureStates = model.featureStore
    }

    private var populatedCategories: [FeatureCategory] {
        catalog.visibleCategories(using: featureStates)
    }

    private var showsProbeOverlay: Bool {
        featureStates.isProbing && !populatedCategories.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            if populatedCategories.isEmpty {
                if featureStates.isProbing {
                    ProbeProgress(store: featureStates, total: catalog.features.count)
                        .frame(maxWidth: 420)
                        .padding(AppTheme.pagePadding)
                        .frame(maxWidth: 760)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityIdentifier("initial-probe-progress")
                } else if featureStates.states.isEmpty {
                    FeatureLoadingState()
                        .padding(AppTheme.pagePadding)
                        .frame(maxWidth: 760)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    WorkspaceStateContainer {
                        ContentUnavailableView(
                            "没有支持的功能",
                            systemImage: "display",
                            description: Text("当前显示器没有可调整的功能")
                        )
                    }
                    .accessibilityIdentifier("no-supported-features-state")
                }
            } else if catalog.hasSearchQuery {
                FeatureSearchResultsPage(model: model)
            } else {
                FeatureCategoryPage(model: model, category: catalog.selectedCategory)
            }
        }
        .background(.clear)
        .overlay(alignment: .bottom) {
            if showsProbeOverlay {
                ProbeProgress(store: featureStates, total: catalog.features.count)
                    .frame(maxWidth: 420)
                    .padding(24)
                    .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: showsProbeOverlay)
        .onChange(of: populatedCategories) { _, categories in
            if !categories.contains(catalog.selectedCategory), let first = categories.first {
                catalog.selectedCategory = first
            }
        }
    }
}
