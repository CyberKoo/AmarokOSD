import SwiftUI

/// Reports the parent view's width and subsequent changes.
struct WidthReader: View {
    let onChange: (Double) -> Void

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear { onChange(proxy.size.width) }
                .onChange(of: proxy.size.width) { _, width in
                    onChange(width)
                }
        }
    }
}
