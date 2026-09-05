extension RFC_791 {

    public struct `Protocol`: RawRepresentable, Hashable, Sendable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt8) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.`Protocol` {

    public static let icmp = Self(__unchecked: (), rawValue: 1)

    public static let igmp = Self(__unchecked: (), rawValue: 2)

    public static let tcp = Self(__unchecked: (), rawValue: 6)

    public static let udp = Self(__unchecked: (), rawValue: 17)

    public static let ipv6 = Self(__unchecked: (), rawValue: 41)

    public static let gre = Self(__unchecked: (), rawValue: 47)

    public static let esp = Self(__unchecked: (), rawValue: 50)

    public static let ah = Self(__unchecked: (), rawValue: 51)

    public static let icmpv6 = Self(__unchecked: (), rawValue: 58)

    public static let sctp = Self(__unchecked: (), rawValue: 132)
}

extension RFC_791.`Protocol`: CustomStringConvertible {
    public var description: String {
        switch rawValue {
        case 1: return "ICMP"
        case 2: return "IGMP"
        case 6: return "TCP"
        case 17: return "UDP"
        case 41: return "IPv6"
        case 47: return "GRE"
        case 50: return "ESP"
        case 51: return "AH"
        case 58: return "ICMPv6"
        case 132: return "SCTP"
        default: return "Protocol(\(rawValue))"
        }
    }
}
