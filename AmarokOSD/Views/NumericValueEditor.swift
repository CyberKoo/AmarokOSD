import SwiftUI

struct NumericValueEditor: View {
    @Binding var value: Double
    let maximum: UInt16
    let isWriting: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text("数值")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value))")
                    .font(.system(.title, design: .rounded).weight(.medium))
                    .monospacedDigit()
                Text("/ \(maximum)")
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 14) {
                NumericStepButton(title: "减小数值", systemName: "minus", action: decrement)
                    .disabled(isWriting || value <= 0)
                Slider(value: $value, in: 0...Double(max(maximum, 1)))
                    .tint(.accentColor)
                    .disabled(maximum == 0 || isWriting)
                    .onChange(of: value) { _, newValue in
                        value = newValue.rounded()
                    }
                NumericStepButton(title: "增大数值", systemName: "plus", action: increment)
                    .disabled(isWriting || value >= Double(maximum))
            }
        }
    }

    private func decrement() {
        value = max(0, value - 1)
    }

    private func increment() {
        value = min(Double(maximum), value + 1)
    }
}
