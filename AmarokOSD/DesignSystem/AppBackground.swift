import SwiftUI

struct AppBackground: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        if reduceTransparency {
            AppTheme.pageBackground
                .ignoresSafeArea()
        } else {
            ZStack {
                AppTheme.pageBackground
                RadialGradient(
                    colors: [Color(red: 0.32, green: 0.86, blue: 0.76).opacity(0.14), .clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 360
                )
                .frame(width: 720, height: 520)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -180, y: -180)
                RadialGradient(
                    colors: [Color(red: 0.25, green: 0.52, blue: 0.94).opacity(0.12), .clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 400
                )
                .frame(width: 800, height: 600)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 180, y: 160)
            }
            .ignoresSafeArea()
        }
    }
}
