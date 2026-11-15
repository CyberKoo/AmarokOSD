import Foundation

enum NumericControlKind {
    case boolean
    case continuous

    init(maximum: UInt16) {
        self = maximum == 1 ? .boolean : .continuous
    }
}
