extension RFC_791.`Protocol` {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty
    }
}

extension RFC_791.`Protocol`.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Protocol data cannot be empty"
        }
    }
}
