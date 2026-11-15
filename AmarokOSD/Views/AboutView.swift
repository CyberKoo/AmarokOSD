import AppKit
import SwiftUI

struct AboutView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text("AmarokOSD")
                    .font(.largeTitle.bold())
                Text("版本 \(version)（\(build)）")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Text("专为 AOC/AGON 显示器设计，通过 DDC/CI 读取和调整画面、色彩与功能设置。")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 6) {
                HStack(spacing: 3) {
                    Image(systemName: "display")
                    Text("由")
                    Link("agon-ctl", destination: URL(string: "https://github.com/CyberKoo/agon-ctl")!)
                        .foregroundStyle(.tint)
                }
                Text("提供 DDC/CI 通信支持")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Button("关闭", action: onClose)
            .liquidGlassButtonStyle()
            .controlSize(.large)
            .keyboardShortcut(.cancelAction)
            .padding(.top, 4)
        }
        .padding(28)
        .frame(width: 360)
        .background(AppBackground())
    }

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
    }

    private var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
    }
}
