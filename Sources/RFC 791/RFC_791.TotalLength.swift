extension RFC_791 {

    public struct TotalLength: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt16

        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt16) {
            guard rawValue >= 20 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.TotalLength {

    public var maximumDataLength: Int {
        Int(rawValue) - 20
    }

    public var isMinimum: Bool {
        rawValue == 20
    }
}

extension RFC_791.TotalLength {

    public static let minimum = RFC_791.TotalLength(__unchecked: (), rawValue: 20)

    public static let maximum = RFC_791.TotalLength(__unchecked: (), rawValue: 65535)

    public static let minimumReassemblyBuffer = RFC_791.TotalLength(__unchecked: (), rawValue: 576)

    public static let ethernetMTU = RFC_791.TotalLength(__unchecked: (), rawValue: 1500)
}

extension RFC_791.TotalLength {

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
        guard value >= 20 else {
            throw .tooSmall(value)
        }

        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.TotalLength: Binary.Serializable {
    public static func serialize<Buffer>(
        _ totalLength: RFC_791.TotalLength,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {

        buffer.append(contentsOf: totalLength.rawValue.bytes(endianness: .big))
    }
}

extension RFC_791.TotalLength: CustomStringConvertible {
    public var description: String {
        "\(rawValue) bytes"
    }
}

extension RFC_791.TotalLength: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
