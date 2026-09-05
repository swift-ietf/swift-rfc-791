public import Byte

extension RFC_791.Precedence {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case valueOutOfRange(_ value: Byte)
    }
}

extension RFC_791.Precedence.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Precedence data cannot be empty"

        case .valueOutOfRange(let value):
            return "Precedence value \(value.bitPattern) is out of range (must be 0-7)"
        }
    }
}
