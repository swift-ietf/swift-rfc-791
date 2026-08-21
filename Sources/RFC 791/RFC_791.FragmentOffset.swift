extension RFC_791 {

    public struct FragmentOffset: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt16

        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt16) {
            guard rawValue <= 0x1FFF else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.FragmentOffset {

    public var byteOffset: Int {
        Int(rawValue) * 8
    }

    public var isFirstFragment: Bool {
        rawValue == 0
    }
}

extension RFC_791.FragmentOffset {

    public static func fromByteOffset(_ bytes: Int) -> RFC_791.FragmentOffset? {
        guard bytes >= 0, bytes <= 65528, bytes % 8 == 0 else {
            return nil
        }
        return RFC_791.FragmentOffset(rawValue: UInt16(bytes / 8))
    }
}

extension RFC_791.FragmentOffset {

    public static let zero = RFC_791.FragmentOffset(__unchecked: (), rawValue: 0)

    public static let maximum = RFC_791.FragmentOffset(__unchecked: (), rawValue: 0x1FFF)
}

extension RFC_791.FragmentOffset {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        var iterator = bytes.makeIterator()

        guard let high = iterator.next() else {
            throw .empty
        }
        guard let low = iterator.next() else {
            throw .insufficientBytes
        }

        let value = (UInt16(high.underlying) << 8 | UInt16(low.underlying)) & 0x1FFF
        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.FragmentOffset: Binary.Serializable {
    public static func serialize<Buffer>(
        _ fragmentOffset: RFC_791.FragmentOffset,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {

        buffer.append(Byte(UInt8((fragmentOffset.rawValue >> 8) & 0x1F)))
        buffer.append(Byte(UInt8(fragmentOffset.rawValue & 0xFF)))
    }
}

extension RFC_791.FragmentOffset: CustomStringConvertible {
    public var description: String {
        "FragmentOffset(\(rawValue) = \(byteOffset) bytes)"
    }
}

extension RFC_791.FragmentOffset: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
