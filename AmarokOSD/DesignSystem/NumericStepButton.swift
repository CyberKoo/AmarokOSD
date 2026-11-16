import SwiftUI

struct NumericStepButton: View {
    let title: String
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "plus")
                    .hidden()
                Image(systemName: systemName)
            }
            .font(.headline)
        }
        .liquidGlassButtonStyle()
        .controlSize(.large)
        .accessibilityLabel(Text(title))
    }
}
