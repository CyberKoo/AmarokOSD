import SwiftUI

struct CardContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppTheme.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .liquidGlass(cornerRadius: AppTheme.cardRadius)
    }
}
