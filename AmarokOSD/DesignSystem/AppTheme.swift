import SwiftUI

enum AppTheme {
    static let pagePadding: Double = 28
    static let sectionSpacing: Double = 22
    static let cardPadding: Double = 20
    static let cardRadius: Double = 20
    static let rowRadius: Double = 13
    static let pageBackground = Color(nsColor: .underPageBackgroundColor)
    static let cardBackground = Color(nsColor: .controlBackgroundColor)
    static let accentGradient = LinearGradient(
        colors: [Color(red: 0.32, green: 0.86, blue: 0.76), Color(red: 0.25, green: 0.52, blue: 0.94)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
