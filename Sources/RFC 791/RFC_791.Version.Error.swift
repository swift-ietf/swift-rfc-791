extension RFC_791.Version {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty
    }
}

extension RFC_791.Version.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Version data cannot be empty"
        }
    }
}
