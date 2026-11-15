import AppKit
import SwiftUI

struct SidebarGlassBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> SidebarGlassEffectView {
        let view = SidebarGlassEffectView()
        view.material = .underWindowBackground
        view.blendingMode = .behindWindow
        view.state = .followsWindowActiveState
        return view
    }

    func updateNSView(_ nsView: SidebarGlassEffectView, context: Context) {}
}

final class SidebarGlassEffectView: NSVisualEffectView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.isOpaque = false
        window?.backgroundColor = .clear
    }
}
