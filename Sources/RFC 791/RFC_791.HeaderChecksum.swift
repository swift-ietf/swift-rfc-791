extension RFC_791 {

    public struct HeaderChecksum: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt16

        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt16) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.HeaderChecksum {

    public static func compute<Bytes: Swift.Collection>(
        over header: Bytes
    ) -> RFC_791.HeaderChecksum where Bytes.Element == Byte {
        var sum: UInt32 = 0
        var iterator = header.makeIterator()

        while let high = iterator.next() {
            let low = iterator.next()?.underlying ?? 0
            sum += UInt32(high.underlying) << 8 | UInt32(low)
        }

        while sum > 0xFFFF {
            sum = (sum & 0xFFFF) + (sum >> 16)
        }

        let checksum = UInt16(~sum & 0xFFFF)
        return RFC_791.HeaderChecksum(__unchecked: (), rawValue: checksum)
    }

    public static func verify<Bytes: Swift.Collection>(
        header: Bytes
    ) -> Bool where Bytes.Element == Byte {
        var sum: UInt32 = 0
        var iterator = header.makeIterator()

        while let high = iterator.next() {
            let low = iterator.next()?.underlying ?? 0
            sum += UInt32(high.underlying) << 8 | UInt32(low)
        }

        while sum > 0xFFFF {
            sum = (sum & 0xFFFF) + (sum >> 16)
        }

        return sum == 0xFFFF
    }
}

extension RFC_791.HeaderChecksum {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        var iterator = bytes.makeIterator()

        guard let high = iterator.next() else {
            throw .empty
        }
        guard let low = iterator.next() else {
            throw .insufficientBytes
        }

        let value = UInt16(high.underlying) << 8 | UInt16(low.underlying)
        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.HeaderChecksum: Binary.Serializable {
    public static func serialize<Buffer>(
        _ headerChecksum: RFC_791.HeaderChecksum,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {

        buffer.append(contentsOf: headerChecksum.rawValue.bytes(endianness: .big))
    }
}

extension RFC_791.HeaderChecksum: CustomStringConvertible {
    public var description: String {
        "0x\(String(rawValue, radix: 16, uppercase: true))"
    }
}

extension RFC_791.HeaderChecksum {

    public static let zero = RFC_791.HeaderChecksum(__unchecked: (), rawValue: 0)
}
