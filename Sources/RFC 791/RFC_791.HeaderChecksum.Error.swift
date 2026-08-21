extension RFC_791.HeaderChecksum {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case insufficientBytes
    }
}

extension RFC_791.HeaderChecksum.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "HeaderChecksum data cannot be empty"

        case .insufficientBytes:
            return "HeaderChecksum requires 2 bytes"
        }
    }
}
