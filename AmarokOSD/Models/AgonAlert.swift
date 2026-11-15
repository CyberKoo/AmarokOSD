import Foundation

struct AgonAlert: Identifiable {
    enum Content {
        case error(AgonError)
        case message(title: String, message: String)
    }

    let id = UUID()
    let content: Content

    init(error: AgonError) {
        content = .error(error)
    }

    init(title: String, message: String) {
        content = .message(title: title, message: message)
    }
}
