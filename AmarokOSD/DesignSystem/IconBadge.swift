import SwiftUI

struct IconBadge: View {
    let systemName: String
    var size: Double = 56
    var showsBackground = false

    var body: some View {
        Image(systemName: systemName)
            .font(size > 48 ? .largeTitle : .title2)
            .foregroundStyle(showsBackground ? Color.white : Color.primary)
            .frame(width: size, height: size)
            .background {
                if showsBackground {
                    RoundedRectangle(cornerRadius: size * 0.28)
                        .fill(AppTheme.accentGradient)
                }
            }
            .accessibilityHidden(true)
    }
}
