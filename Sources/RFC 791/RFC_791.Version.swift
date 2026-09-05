extension RFC_791 {

    public struct Version: RawRepresentable, Hashable, Sendable {

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
