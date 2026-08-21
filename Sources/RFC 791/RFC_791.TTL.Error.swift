extension RFC_791.TTL {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty
    }
}

extension RFC_791.TTL.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "TTL data cannot be empty"
        }
    }
}
