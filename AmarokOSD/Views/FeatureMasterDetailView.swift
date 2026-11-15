import SwiftUI

struct FeatureMasterDetailView: View {
    let model: AppModel
    let title: String
    let subtitle: String
    let features: [AgonFeature]
    @ObservedObject var catalog: FeatureCatalogStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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

    var body: some View {
        HStack(spacing: 20) {
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
            .frame(width: 302)
            .frame(maxHeight: .infinity)
            .liquidGlass(cornerRadius: AppTheme.cardRadius)
            .animation(transitionAnimation, value: title)

            Group {
                if let selectedFeature {
                    FeatureDetailContainer(model: model, feature: selectedFeature)
                        .id(selectedFeature.name)
                        .transition(.opacity)
                } else {
                    ContentUnavailableView(
                        "选择一项功能",
                        systemImage: "slider.horizontal.3",
                        description: Text("从左侧列表选择要查看和调整的显示器设置")
                    )
                    .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(transitionAnimation, value: selectedFeature?.name)
        }
        .padding(20)
        .onAppear(perform: synchronizeSelection)
        .onChange(of: features) { _, _ in synchronizeSelection() }
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
                            tint: Color.accentColor.opacity(0.18),
                            interactive: true
                        )
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(feature.title))
        .accessibilityHint(Text("在右侧调整设置"))
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
