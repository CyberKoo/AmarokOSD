import SwiftUI

struct DisplayDetails: View {
    let display: AgonDisplay
    @State private var showInfo = false

    var body: some View {
        CardContainer {
            HStack(spacing: 11) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                VStack(alignment: .leading, spacing: 2) {
                    Text("已连接")
                        .font(.callout.weight(.medium))
                    Text(display.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Button("显示器信息", systemImage: "info.circle") {
                    showInfo = true
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .accessibilityLabel(Text("显示器信息"))
                .accessibilityIdentifier("display-info")
            }
        }
        .padding(4)
        .popover(isPresented: $showInfo, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                Text(display.name)
                    .font(.headline)
                DisplayDetailLine(label: "厂商", value: display.vendorLabel)
                DisplayDetailLine(label: "型号", value: display.modelLabel)
                DisplayDetailLine(label: "序列号", value: "\(display.serialNumber)")
                DisplayDetailLine(label: "位置", value: display.location)
            }
            .padding(18)
            .frame(width: 300, alignment: .leading)
        }
    }
}
