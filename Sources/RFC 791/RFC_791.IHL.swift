extension RFC_791 {

    public struct IHL: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt8) {
            guard rawValue >= 5, rawValue <= 15 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.IHL {

    public var byteLength: Int {
        Int(rawValue) * 4
    }

    public var optionsLength: Int {
        byteLength - 20
    }

    public var hasOptions: Bool {
        rawValue > 5
    }
}

extension RFC_791.IHL {

    public static let minimum = RFC_791.IHL(__unchecked: (), rawValue: 5)

    public static let maximum = RFC_791.IHL(__unchecked: (), rawValue: 15)
}

extension RFC_791.IHL {

    public static func fromByteLength(_ bytes: Int) -> RFC_791.IHL? {
        guard bytes >= 20, bytes <= 60, bytes % 4 == 0 else {
            return nil
        }
        return RFC_791.IHL(rawValue: UInt8(bytes / 4))
    }
}

extension RFC_791.IHL {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard let firstByte = bytes.first else {
            throw .empty
        }

        let ihl = firstByte.underlying & 0x0F

        guard ihl >= 5 else {
            throw .tooSmall(ihl)
        }

        self.init(__unchecked: (), rawValue: ihl)
    }
}

extension RFC_791.IHL: Binary.Serializable {
    public static func serialize<Buffer>(
        _ ihl: RFC_791.IHL,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {

        buffer.append(contentsOf: ihl.rawValue.bytes(endianness: .big))
    }
}

extension RFC_791.IHL: CustomStringConvertible {
    public var description: String {
        "IHL(\(rawValue) words, \(byteLength) bytes)"
    }
}

extension RFC_791.IHL: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
