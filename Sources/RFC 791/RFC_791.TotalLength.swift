extension RFC_791 {

    public struct TotalLength: RawRepresentable, Hashable, Sendable {

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
