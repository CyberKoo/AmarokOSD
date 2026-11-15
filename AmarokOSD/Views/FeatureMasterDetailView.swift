import SwiftUI

struct FeatureMasterDetailView: View {
    let model: AppModel
    let title: String
    let subtitle: String
    let features: [AgonFeature]
    @ObservedObject var catalog: FeatureCatalogStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var availableWidth: Double = 0

    init(model: AppModel, title: String, subtitle: String, features: [AgonFeature]) {
        self.model = model
        self.title = title
        self.subtitle = subtitle
        self.features = features
        catalog = model.catalogStore
    }

    private var selectedFeature: AgonFeature? {
        features.first { $0.name == catalog.selectedName } ?? features.first
    }

    private var transitionAnimation: Animation? {
        reduceMotion ? nil : .easeOut(duration: 0.14)
    }

    private var usesStackedLayout: Bool {
        availableWidth > 0 && availableWidth < 640
    }

    private var listWidth: Double {
        availableWidth < 760 ? 240 : 302
    }

    var body: some View {
        Group {
            if usesStackedLayout {
                VStack(spacing: 16) {
                    featureList
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                    detail
                }
            } else {
                HStack(spacing: 20) {
                    featureList
                        .frame(width: listWidth)
                    detail
                }
            }
        }
        .padding(20)
        .background(WidthReader { availableWidth = $0 })
        .onAppear(perform: synchronizeSelection)
        .onChange(of: features) { _, _ in synchronizeSelection() }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(title)
                        .font(.title2.bold())
                    Spacer()
                    Text("\(features.count)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Text(subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 15)

            Divider()
                .opacity(0.35)

            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(features) { feature in
                        FeatureListRow(
                            feature: feature,
                            store: model.featureStore,
                            isSelected: feature.name == selectedFeature?.name,
                            action: { model.selectFeature(feature.name) }
                        )
                    }
                }
                .padding(8)
            }
            .id(title)
            .transition(.opacity)
        }
        .frame(maxHeight: .infinity)
        .liquidGlass(cornerRadius: AppTheme.cardRadius)
        .animation(transitionAnimation, value: title)
        .accessibilityIdentifier("feature-master-list")
    }

    private var detail: some View {
        Group {
            if let selectedFeature {
                FeatureDetailContainer(model: model, feature: selectedFeature)
                    .id(selectedFeature.name)
                    .transition(.opacity)
            } else {
                CardContainer {
                    ContentUnavailableView(
                        "选择一项功能",
                        systemImage: "slider.horizontal.3",
                        description: Text("从左侧列表选择要查看和调整的显示器设置")
                    )
                    .frame(maxWidth: .infinity, minHeight: 220)
                }
                .padding(AppTheme.pagePadding)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .liquidGlass(cornerRadius: AppTheme.cardRadius)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .animation(transitionAnimation, value: selectedFeature?.name)
        .accessibilityIdentifier("feature-detail-surface")
    }

    private func synchronizeSelection() {
        guard let selectedFeature else {
            model.selectFeature(nil)
            return
        }
        model.selectFeature(selectedFeature.name)
    }
}

private struct FeatureListRow: View {
    let feature: AgonFeature
    @ObservedObject var store: FeatureStateStore
    let isSelected: Bool
    let action: () -> Void

    private var stateDescription: String {
        switch store.state(for: feature) {
        case .idle: "未读取"
        case .loading: "正在读取"
        case .unsupported: "不支持"
        case .ready(let value): "当前值 \(value.displayText(for: feature))"
        case .failed: "读取失败"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 11) {
                Image(systemName: feature.iconName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                    .frame(width: 22)

                Text(feature.title)
                    .font(.body.weight(isSelected ? .semibold : .regular))
                    .lineLimit(1)

                Spacer(minLength: 6)

                FeatureListValue(feature: feature, state: store.state(for: feature))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .frame(minHeight: 54)
            .foregroundStyle(.primary)
            .contentShape(RoundedRectangle(cornerRadius: AppTheme.rowRadius))
            .background {
                if isSelected {
                    Color.clear
                        .liquidGlass(
                            cornerRadius: AppTheme.rowRadius,
                            tint: AppTheme.selectionTint,
                            interactive: true
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(feature.title))
        .accessibilityValue(Text(stateDescription))
        .accessibilityHint(Text("在右侧调整设置"))
        .help("\(feature.title)：\(stateDescription)")
        .accessibilityIdentifier("feature-row-\(feature.name)")
    }
}

private struct FeatureListValue: View {
    let feature: AgonFeature
    let state: AgonFeatureState

    var body: some View {
        Group {
            switch state {
            case .idle:
                Text("—")
                    .foregroundStyle(.tertiary)
            case .loading:
                ProgressView()
                    .controlSize(.small)
            case .unsupported:
                Text("不支持")
                    .foregroundStyle(.tertiary)
            case .ready(let value):
                Text(value.displayText(for: feature))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .help("读取失败")
            }
        }
        .font(.callout)
        .foregroundStyle(.secondary)
        .frame(maxWidth: 104, alignment: .trailing)
    }
}
