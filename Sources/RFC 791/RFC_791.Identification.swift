extension RFC_791 {

    public struct Identification: RawRepresentable, Hashable, Sendable {

        public let rawValue: UInt16

        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt16) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
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
