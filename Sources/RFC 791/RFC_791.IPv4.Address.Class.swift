extension RFC_791.IPv4.Address {

    public enum Class: Sendable, Hashable {

        case a

        case b

        case c

        case d

        case e
    }
}

extension RFC_791.IPv4.Address {

    public var `class`: Class {
        let firstOctet = UInt8((rawValue >> 24) & 0xFF)

        if firstOctet & 0b1000_0000 == 0 {

            return .a
        } else if firstOctet & 0b1100_0000 == 0b1000_0000 {

            return .b
        } else if firstOctet & 0b1110_0000 == 0b1100_0000 {

            return .c
        } else if firstOctet & 0b1111_0000 == 0b1110_0000 {

            return .d
        } else {

            return .e
        }
    }
}

extension RFC_791.IPv4.Address {

    public struct Is: Sendable {
        @usableFromInline
        let address: RFC_791.IPv4.Address

        @usableFromInline
        init(_ address: RFC_791.IPv4.Address) {
            self.address = address
        }
    }

    public var `is`: Is {
        Is(self)
    }
}

extension RFC_791.IPv4.Address.Is {

    @inlinable
    public var multicast: Bool {
        address.class == .d
    }

    @inlinable
    public var reserved: Bool {
        address.class == .e
    }
}

extension RFC_791.IPv4.Address.Class: CustomStringConvertible {
    public var description: String {
        switch self {
        case .a: return "Class A"
        case .b: return "Class B"
        case .c: return "Class C"
        case .d: return "Class D (Multicast)"
        case .e: return "Class E (Reserved)"
        }
    }
}
