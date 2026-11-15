import SwiftUI

struct AppBackground: View {
    let showsAccents: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(showsAccents: Bool = false) {
        self.showsAccents = showsAccents
    }

    var body: some View {
        if reduceTransparency || !showsAccents {
            AppTheme.pageBackground
                .ignoresSafeArea()
        } else {
            ZStack {
                AppTheme.pageBackground
                Circle()
                    .fill(Color(red: 0.32, green: 0.86, blue: 0.76).opacity(0.14))
                    .frame(width: 520, height: 520)
                    .blur(radius: 110)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: -180, y: -180)
                Circle()
                    .fill(Color(red: 0.25, green: 0.52, blue: 0.94).opacity(0.12))
                    .frame(width: 620, height: 620)
                    .blur(radius: 130)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: 180, y: 160)
            }
            .ignoresSafeArea()
        }
    }
}
