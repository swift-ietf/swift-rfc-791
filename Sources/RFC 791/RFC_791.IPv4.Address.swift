public import Byte
import ASCII
import Byte_Standard_Library_Integration

extension RFC_791.IPv4 {

    public struct Address: Hashable, Sendable {

        public let rawValue: UInt32

        init(__unchecked: Void, rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public init(rawValue: UInt32) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

extension RFC_791.IPv4.Address {

    public init(_ octet1: Byte, _ octet2: Byte, _ octet3: Byte, _ octet4: Byte) {

        let value =
            UInt32(octet1.bitPattern) << 24
            | UInt32(octet2.bitPattern) << 16
            | UInt32(octet3.bitPattern) << 8
            | UInt32(octet4.bitPattern)
        self.init(__unchecked: (), rawValue: value)
    }
}

extension RFC_791.IPv4.Address {

    public var octets: (Byte, Byte, Byte, Byte) {
        (
            Byte(bitPattern: UInt8((rawValue >> 24) & 0xFF)),
            Byte(bitPattern: UInt8((rawValue >> 16) & 0xFF)),
            Byte(bitPattern: UInt8((rawValue >> 8) & 0xFF)),
            Byte(bitPattern: UInt8(rawValue & 0xFF))
        )
    }
}

extension RFC_791.IPv4.Address {

    public var bigEndian: UInt32 {
        rawValue.bigEndian
    }
}

extension RFC_791.IPv4.Address {

    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard !bytes.isEmpty else {
            throw .empty
        }

        let codes: [ASCII.Code]
        do throws(ASCII.Code.Error) {
            var collected: [ASCII.Code] = []
            collected.reserveCapacity(bytes.count)
            for byte in bytes {
                collected.append(try ASCII.Code(byte))
            }
            codes = collected
        } catch {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }

        var octets: [UInt8] = []
        octets.reserveCapacity(4)

        var currentOctet: Int = 0
        var digitCount = 0
        var position = 0

        for code in codes {
            if code == ASCII.Code.period {

                guard digitCount > 0 else {
                    throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
                }
                guard currentOctet <= 255 else {
                    throw .octetOutOfRange(currentOctet, position: position)
                }
                octets.append(UInt8(currentOctet))
                currentOctet = 0
                digitCount = 0
                position += 1
            } else if code.isDigit {

                if digitCount == 1, currentOctet == 0 {
                    throw .leadingZero(String(decoding: bytes, as: UTF8.self), position: position)
                }
                currentOctet = currentOctet * 10 + Int(code.digitValue!)
                digitCount += 1

                if currentOctet > 255 {
                    throw .octetOutOfRange(currentOctet, position: position)
                }
            } else {
                throw .invalidCharacter(
                    String(decoding: bytes, as: UTF8.self),
                    code: code,
                    position: position
                )
            }
        }

        guard digitCount > 0 else {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }
        guard currentOctet <= 255 else {
            throw .octetOutOfRange(currentOctet, position: position)
        }
        octets.append(UInt8(currentOctet))

        guard octets.count == 4 else {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }

        self.init(
            Byte(bitPattern: octets[0]),
            Byte(bitPattern: octets[1]),
            Byte(bitPattern: octets[2]),
            Byte(bitPattern: octets[3])
        )
    }
}

extension RFC_791.IPv4.Address {

    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: string.utf8.map(Byte.init(bitPattern:)))
    }
}

extension RFC_791.IPv4.Address: CustomStringConvertible {

    public var description: String {
        let (a, b, c, d) = octets
        return "\(a.bitPattern).\(b.bitPattern).\(c.bitPattern).\(d.bitPattern)"
    }
}

extension RFC_791.IPv4.Address: Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension RFC_791.IPv4.Address {

    public static let `any` = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0)

    public static let broadcast = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0xFFFF_FFFF)

    public static let loopback = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0x7F00_0001)
}
