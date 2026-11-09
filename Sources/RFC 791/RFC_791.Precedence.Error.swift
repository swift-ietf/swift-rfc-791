extension RFC_791.Precedence {

    public enum Error: Swift::Error, Sendable, Equatable {

        case empty
    }
}

extension RFC_791.Precedence.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Precedence data cannot be empty"
        }
    }
}
