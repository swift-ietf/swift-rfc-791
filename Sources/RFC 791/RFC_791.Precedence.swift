extension RFC_791 {

    public struct Precedence: RawRepresentable, Hashable, Sendable, Codable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt8) {
            guard rawValue <= 7 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.Precedence {

    public static let routine = RFC_791.Precedence(__unchecked: (), rawValue: 0)

    public static let priority = RFC_791.Precedence(__unchecked: (), rawValue: 1)

    public static let immediate = RFC_791.Precedence(__unchecked: (), rawValue: 2)

    public static let flash = RFC_791.Precedence(__unchecked: (), rawValue: 3)

    public static let flashOverride = RFC_791.Precedence(__unchecked: (), rawValue: 4)

    public static let criticEcp = RFC_791.Precedence(__unchecked: (), rawValue: 5)

    public static let internetworkControl = RFC_791.Precedence(__unchecked: (), rawValue: 6)

    public static let networkControl = RFC_791.Precedence(__unchecked: (), rawValue: 7)
}

extension RFC_791.Precedence {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard let firstByte = bytes.first else {
            throw .empty
        }

        let value = firstByte.bitPattern

        guard value <= 7 else {
            throw .valueOutOfRange(firstByte)
        }

        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.Precedence: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ precedence: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(Byte(bitPattern: precedence.rawValue))
    }
}

extension RFC_791.Precedence: CustomStringConvertible {
    public var description: String {
        switch rawValue {
        case 0: return "Routine"
        case 1: return "Priority"
        case 2: return "Immediate"
        case 3: return "Flash"
        case 4: return "Flash Override"
        case 5: return "CRITIC/ECP"
        case 6: return "Internetwork Control"
        case 7: return "Network Control"
        default: return "Unknown(\(rawValue))"
        }
    }
}

extension RFC_791.Precedence: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension [Byte] {

    public init(_ precedence: RFC_791.Precedence) {
        self = [Byte(bitPattern: precedence.rawValue)]
    }
}
