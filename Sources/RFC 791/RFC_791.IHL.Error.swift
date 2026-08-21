extension RFC_791.IHL {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case tooSmall(_ value: UInt8)
    }
}

extension RFC_791.IHL.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "IHL data cannot be empty"

        case .tooSmall(let value):
            return "IHL value \(value) is too small (minimum is 5)"
        }
    }
}
