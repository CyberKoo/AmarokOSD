import SwiftUI

struct BooleanValueEditor: View {
    @Binding var value: Double
    let isWriting: Bool

    var body: some View {
        HStack(spacing: 16) {
            Text(value == 1 ? "开启" : "关闭")
                .font(.title3.bold())
            Spacer()
            Toggle("开启或关闭", isOn: isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.large)
                .disabled(isWriting)
        }
        .padding(.vertical, 4)
    }

    private var isOn: Binding<Bool> {
        Binding(
            get: { value == 1 },
            set: { value = $0 ? 1 : 0 }
        )
    }
}
