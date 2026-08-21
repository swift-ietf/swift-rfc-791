extension RFC_791.TotalLength {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case insufficientBytes

        case tooSmall(UInt16)
    }
}

extension RFC_791.TotalLength.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "TotalLength data cannot be empty"

        case .insufficientBytes:
            return "TotalLength requires 2 bytes"

        case .tooSmall(let value):
            return "TotalLength \(value) is less than minimum header size of 20"
        }
    }
}
