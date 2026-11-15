import SwiftUI

struct FeatureDraftEditor: View {
    let strategy: FeatureRenderStrategy
    let isWriting: Bool
    @Binding var numericDraft: Double
    @Binding var namedDraft: UInt16
    let current: UInt16

    var body: some View {
        switch strategy {
        case .number(let maximum):
            switch NumericControlKind(maximum: maximum) {
            case .boolean:
                BooleanValueEditor(value: $numericDraft, isWriting: isWriting)
            case .continuous:
                NumericValueEditor(value: $numericDraft, maximum: maximum, isWriting: isWriting)
            }
        case .capabilityList(let values):
            NamedValueEditor(
                namedValues: values,
                selection: $namedDraft,
                current: current,
                isWriting: isWriting,
                emptyMessage: "设备未报告可选值"
            )
        case .maximum(let values):
            NamedValueEditor(
                namedValues: values,
                selection: $namedDraft,
                current: current,
                isWriting: isWriting,
                emptyMessage: "设备最大值没有匹配的命名值"
            )
        case .staticNamed(let values):
            NamedValueEditor(
                namedValues: values,
                selection: $namedDraft,
                current: current,
                isWriting: isWriting,
                emptyMessage: "没有可用的静态命名值",
                sourceNote: "候选值来自内置名称表，未经设备列表确认。"
            )
        }
    }
}
