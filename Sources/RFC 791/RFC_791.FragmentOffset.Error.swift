extension RFC_791.FragmentOffset {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case insufficientBytes
    }
}

extension RFC_791.FragmentOffset.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "FragmentOffset data cannot be empty"

        case .insufficientBytes:
            return "FragmentOffset requires 2 bytes"
        }
    }
}
