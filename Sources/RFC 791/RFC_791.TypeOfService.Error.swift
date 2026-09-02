extension RFC_791.TypeOfService {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case reservedBitsSet(_ value: Byte)
    }
}

extension RFC_791.TypeOfService.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Type of Service data cannot be empty"

        case .reservedBitsSet(let value):
            let hex = String(value.bitPattern, radix: 16, uppercase: true)
            return "Type of Service value 0x\(hex) has reserved bits set (bits 6-7 must be zero)"
        }
    }
}
