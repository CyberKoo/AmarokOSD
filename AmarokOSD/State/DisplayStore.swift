import Foundation

@MainActor
final class DisplayStore: ObservableObject {
    @Published var displays: [AgonDisplay] = []
    @Published var selectedID: String?
    @Published var isRefreshing = false
    @Published var hasRefreshed = false

    var selectedDisplay: AgonDisplay? {
        displays.first { $0.id == selectedID }
    }
}
