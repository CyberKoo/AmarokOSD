import Foundation

extension AgonAlert {
    var title: String {
        switch content {
        case .error(let error): error.title
        case .message(let title, _): title
        }
    }

    var message: String {
        switch content {
        case .error(let error): error.alertMessage
        case .message(_, let message): message
        }
    }
}
