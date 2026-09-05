extension RFC_791 {

    public struct TTL: RawRepresentable, Hashable, Sendable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt8) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.TTL {

    public var isExpired: Bool {
        rawValue == 0
    }

    public var decremented: RFC_791.TTL? {
        guard rawValue > 0 else { return nil }
        return RFC_791.TTL(__unchecked: (), rawValue: rawValue - 1)
    }
}

extension RFC_791.TTL {

    public static let default64 = RFC_791.TTL(__unchecked: (), rawValue: 64)

    public static let default128 = RFC_791.TTL(__unchecked: (), rawValue: 128)

    public static let maximum = RFC_791.TTL(__unchecked: (), rawValue: 255)

    public static let expired = RFC_791.TTL(__unchecked: (), rawValue: 0)

    public static let linkLocal = RFC_791.TTL(__unchecked: (), rawValue: 1)
}

extension RFC_791.TTL: CustomStringConvertible {
    public var description: String {
        "TTL(\(rawValue))"
    }
}

extension RFC_791.TTL: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension RFC_791.TTL: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt8) {
        self.init(__unchecked: (), rawValue: value)
    }
}
