extension RFC_791.Identification {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case insufficientBytes
    }
}

extension RFC_791.Identification.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Identification data cannot be empty"

        case .insufficientBytes:
            return "Identification requires 2 bytes"
        }
    }
}
