public import Binary_Parseable
public import Parseable_ASCII

extension RFC_791.IPv4 {

    public struct Address: Hashable, Sendable, Codable {

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
            UInt32(octet1.underlying) << 24
            | UInt32(octet2.underlying) << 16
            | UInt32(octet3.underlying) << 8
            | UInt32(octet4.underlying)
        self.init(__unchecked: (), rawValue: value)
    }

}

extension RFC_791.IPv4.Address {

    public var octets: (Byte, Byte, Byte, Byte) {
        (
            Byte(UInt8((rawValue >> 24) & 0xFF)),
            Byte(UInt8((rawValue >> 16) & 0xFF)),
            Byte(UInt8((rawValue >> 8) & 0xFF)),
            Byte(UInt8(rawValue & 0xFF))
        )
    }
}

extension RFC_791.IPv4.Address {

    public var bigEndian: UInt32 {
        rawValue.bigEndian
    }
}

extension RFC_791.IPv4.Address: Binary.Serializable {
    public static func serialize<Buffer>(
        _ address: RFC_791.IPv4.Address,
        into buffer: inout Buffer
    ) where Buffer: Swift.RangeReplaceableCollection, Buffer.Element == Byte {
        let (a, b, c, d) = address.octets
        buffer.append(a)
        buffer.append(b)
        buffer.append(c)
        buffer.append(d)
    }

    public init<Bytes: Swift.Collection>(binary bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard bytes.count == 4 else {
            throw .invalidFormat("Expected 4 bytes, got \(bytes.count)")
        }

        var iterator = bytes.makeIterator()
        let a = iterator.next()!
        let b = iterator.next()!
        let c = iterator.next()!
        let d = iterator.next()!

        self.init(a, b, c, d)
    }
}

extension RFC_791.IPv4.Address: Binary.Parseable {

    public static func parse<Source>(
        from source: inout Source
    ) throws(Binary.Parse.Failure) -> RFC_791.IPv4.Address
    where Source: Swift.RangeReplaceableCollection, Source.Element == Byte {
        guard source.count >= 4 else {
            throw .insufficient(needed: 4)
        }

        var iterator = source.makeIterator()
        let a = iterator.next()!
        let b = iterator.next()!
        let c = iterator.next()!
        let d = iterator.next()!
        source.removeFirst(4)

        return RFC_791.IPv4.Address(a, b, c, d)
    }
}

extension RFC_791.IPv4.Address: ASCII.Serializable {

    public static func serialize<Buffer>(
        _ address: RFC_791.IPv4.Address,
        into buffer: inout Buffer
    ) where Buffer: Swift.RangeReplaceableCollection, Buffer.Element == ASCII.Code {
        let (a, b, c, d) = address.octets

        buffer.reserveCapacity(15)

        func appendDecimal(_ value: UInt8) {

            if value < 10 {
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ value))
                return
            }

            if value < 100 {
                let tens = value / 10
                let ones = value % 10
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ tens))
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ ones))
                return
            }

            let hundreds = value / 100
            let remainder = value % 100
            let tens = remainder / 10
            let ones = remainder % 10

            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ hundreds))
            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ tens))
            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ ones))
        }

        appendDecimal(a.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(b.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(c.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(d.underlying)
    }
}

extension RFC_791.IPv4.Address: ASCII.Parseable {

    public typealias Failure = RFC_791.IPv4.Address.Error

    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard !bytes.isEmpty else {
            throw .empty
        }

        let arr: [ASCII.Code]
        do throws(ASCII.Code.Error) {

            arr = try Swift.Array<ASCII.Code>(bytes)
        } catch {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }

        var octets: [UInt8] = []
        octets.reserveCapacity(4)

        var currentOctet: Int = 0
        var digitCount = 0
        var position = 0

        for code in arr {
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

        self.init(Byte(octets[0]), Byte(octets[1]), Byte(octets[2]), Byte(octets[3]))
    }
}

extension RFC_791.IPv4.Address: CustomStringConvertible {

    public var description: String {
        String(decoding: serialized, as: UTF8.self)
    }
}

extension RFC_791.IPv4.Address {

    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: [Byte](string.utf8))
    }
}

extension RFC_791.IPv4.Address: Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension RFC_791.IPv4.Address: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        do throws(Error) {
            try self.init(value)
        } catch {
            preconditionFailure("Invalid IPv4 address literal '\(value)': \(error)")
        }
    }
}

extension RFC_791.IPv4.Address {

    public static let `any` = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0)

    public static let broadcast = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0xFFFF_FFFF)

    public static let loopback = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0x7F00_0001)
}
