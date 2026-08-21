extension RFC_791.Flags {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case reservedBitSet(_ value: Byte)
    }
}

extension RFC_791.Flags.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "IP Flags data cannot be empty"

        case .reservedBitSet(let value):
            let hex = String(value.underlying, radix: 16, uppercase: true)
            return "IP Flags value 0x\(hex) has reserved bit set (bit 0 must be zero)"
        }
    }
}
