public import Binary_Endianness
public import Binary_Standard_Library_Integration

extension RFC_791 {

    public struct Identification: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt16

        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt16) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.Identification {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        var iterator = bytes.makeIterator()

        guard let high = iterator.next() else {
            throw .empty
        }
        guard let low = iterator.next() else {
            throw .insufficientBytes
        }

        let value = UInt16(high.bitPattern) << 8 | UInt16(low.bitPattern)
        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.Identification: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ identification: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        buffer.append(contentsOf: identification.rawValue.bytes(endianness: .big))
    }
}

extension [Byte] {

    public init(_ identification: RFC_791.Identification) {
        self = identification.rawValue.bytes(endianness: .big)
    }
}

extension RFC_791.Identification: CustomStringConvertible {
    public var description: String {
        "0x\(String(rawValue, radix: 16, uppercase: true))"
    }
}

extension RFC_791.Identification: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension RFC_791.Identification: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt16) {
        self.init(__unchecked: (), rawValue: value)
    }
}
