import SwiftUI

struct FeatureValueEditor: View {
    let feature: AgonFeature
    let value: AgonValue
    let isWriting: Bool
    let isReading: Bool
    let onWrite: (UInt16, Bool) -> Void

    @State private var numericDraft: Double = 0
    @State private var namedDraft: UInt16 = 0
    @State private var showWriteConfirmation = false

    var body: some View {
        CardContainer {
            VStack(spacing: 20) {
                HStack {
                    Label("调整设置", systemImage: "slider.horizontal.3")
                        .font(.headline)
                    Spacer()
                    status
                }
                FeatureDraftEditor(
                    strategy: strategy,
                    isWriting: isWriting || isReading,
                    numericDraft: $numericDraft,
                    namedDraft: $namedDraft,
                    current: value.current
                )
                HStack {
                    if hasChanges {
                        Text("有未应用的更改")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("应用设置", systemImage: "checkmark", action: requestWrite)
                        .liquidGlassButtonStyle(prominent: true)
                        .controlSize(.large)
                        .disabled(!canApply)
                        .accessibilityIdentifier("feature-apply")
                }
            }
        }
        .onAppear(perform: synchronize)
        .onChange(of: value) { _, _ in synchronize() }
        .onChange(of: feature.name) { _, _ in synchronize() }
        .alert("确认修改\(feature.title)？", isPresented: $showWriteConfirmation) {
            Button("取消", role: .cancel) {}
            Button("继续设置") {
                writeDraft(confirmed: true)
            }
        } message: {
            Text("此操作可能中断当前画面或启动面板维护流程，请确认显示器当前状态。")
        }
    }

    private var strategy: FeatureRenderStrategy {
        feature.renderStrategy(for: value)
    }

    private var hasChanges: Bool {
        if strategy.numericMaximum != nil {
            return numericDraft != Double(value.current)
        }
        return namedDraft != value.current
    }

    private var canApply: Bool {
        guard hasChanges, !isWriting, !isReading else { return false }
        if let maximum = feature.numericMaximum(for: value) {
            return maximum > 0 && numericDraft >= 0 && numericDraft <= Double(maximum)
        }
        return feature.canWrite(namedDraft, for: value)
    }

    private var status: some View {
        Group {
            if isWriting {
                WriteProgress(isWriting: true)
            } else if isReading {
                Label("正在读取", systemImage: "arrow.clockwise")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Label("已读取", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .liquidGlass(
            cornerRadius: 12,
            tint: !isWriting && !isReading ? Color.green.opacity(0.12) : nil
        )
    }

    private func synchronize() {
        numericDraft = Double(value.current)
        namedDraft = value.current
    }

    private func requestWrite() {
        if feature.requiresWriteConfirmation {
            showWriteConfirmation = true
        } else {
            writeDraft(confirmed: false)
        }
    }

    private func writeDraft(confirmed: Bool) {
        onWrite(strategy.numericMaximum == nil ? namedDraft : UInt16(numericDraft), confirmed)
    }
}
