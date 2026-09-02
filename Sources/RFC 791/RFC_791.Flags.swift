extension RFC_791 {

    public struct Flags: Hashable, Sendable, Codable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt8) {

            guard rawValue & 0b100 == 0 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }

        public init(
            dontFragment: Bool = false,
            moreFragments: Bool = false
        ) {
            var pattern: UInt8 = 0
            if dontFragment { pattern |= 0b010 }
            if moreFragments { pattern |= 0b001 }
            self.init(__unchecked: (), rawValue: pattern)
        }
    }
}

extension RFC_791.Flags {

    public var dontFragment: Bool {
        (rawValue & 0b010) != 0
    }

    public var moreFragments: Bool {
        (rawValue & 0b001) != 0
    }
}

extension RFC_791.Flags {

    public static let none = RFC_791.Flags(__unchecked: (), rawValue: 0)

    public static let dontFragment = RFC_791.Flags(__unchecked: (), rawValue: 0b010)

    public static let moreFragments = RFC_791.Flags(__unchecked: (), rawValue: 0b001)
}

extension RFC_791.Flags {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard let firstByte = bytes.first else {
            throw .empty
        }

        let flags = firstByte.bitPattern >> 5

        guard flags & 0b100 == 0 else {
            throw .reservedBitSet(firstByte)
        }

        self.init(__unchecked: (), rawValue: flags)
    }
}

extension RFC_791.Flags: Binary.Serializable {
    public static func serialize<Buffer>(
        _ flags: RFC_791.Flags,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
        buffer.append(contentsOf: [Byte(bitPattern: flags.rawValue << 5)])
    }
}

extension RFC_791.Flags: CustomStringConvertible {
    public var description: String {
        var flags: [String] = []
        if dontFragment { flags.append("DF") }
        if moreFragments { flags.append("MF") }

        if flags.isEmpty {
            return "Flags(none)"
        }
        return "Flags(\(flags.joined(separator: ", ")))"
    }
}

extension [Byte] {

    public init(_ flags: RFC_791.Flags) {
        self = [Byte(bitPattern: flags.rawValue << 5)]
    }
}
