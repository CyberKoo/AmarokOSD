import Foundation

@MainActor
final class AlertStore: ObservableObject {
    @Published var alert: AgonAlert?
}
