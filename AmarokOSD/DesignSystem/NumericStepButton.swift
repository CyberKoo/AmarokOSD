import SwiftUI

struct NumericStepButton: View {
    let title: String
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(title, systemImage: systemName, action: action)
            .labelStyle(.iconOnly)
            .font(.headline)
            .liquidGlassButtonStyle()
            .controlSize(.large)
            .frame(width: 40, height: 40)
            .accessibilityLabel(Text(title))
    }
}
