extension RFC_791 {

    public struct Version: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt8) {
            guard rawValue <= 15 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.Version {

    public static let v4 = RFC_791.Version(__unchecked: (), rawValue: 4)

    public static let v6 = RFC_791.Version(__unchecked: (), rawValue: 6)
}

extension RFC_791.Version {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard let firstByte = bytes.first else {
            throw .empty
        }

        let version = firstByte.bitPattern >> 4

        self.init(__unchecked: (), rawValue: version)
    }
}

extension RFC_791.Version: Binary.Serializable {
    public static func serialize<Buffer>(
        _ version: RFC_791.Version,
        into buffer: inout Buffer
    ) where Buffer: RangeReplaceableCollection, Buffer.Element == Byte {
        buffer.append(Byte(bitPattern: version.rawValue << 4))
    }
}

extension RFC_791.Version {

    public var isIPv4: Bool {
        rawValue == 4
    }

    public var isIPv6: Bool {
        rawValue == 6
    }
}

extension RFC_791.Version: CustomStringConvertible {
    public var description: String {
        switch rawValue {
        case 4: return "IPv4"
        case 6: return "IPv6"
        default: return "Version(\(rawValue))"
        }
    }
}

extension RFC_791.Version: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
