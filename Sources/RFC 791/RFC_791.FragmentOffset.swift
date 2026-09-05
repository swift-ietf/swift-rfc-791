extension RFC_791 {

    public struct FragmentOffset: RawRepresentable, Hashable, Sendable {

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
