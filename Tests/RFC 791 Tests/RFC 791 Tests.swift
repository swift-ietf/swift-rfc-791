import Byte
import RFC_791
import Testing

@Suite
struct `RFC 791 Tests` {
    @Suite struct `IPv4 Address Tests` {}
    @Suite struct `IPv4 Address Class Tests` {}
    @Suite struct `Version Tests` {}
    @Suite struct `IHL Tests` {}
    @Suite struct `Type of Service Tests` {}
    @Suite struct `Precedence Tests` {}
    @Suite struct `Total Length Tests` {}
    @Suite struct `Identification Tests` {}
    @Suite struct `Flags Tests` {}
    @Suite struct `Fragment Offset Tests` {}
    @Suite struct `TTL Tests` {}
    @Suite struct `Protocol Tests` {}
    @Suite struct `Header Checksum Tests` {}
}

extension RFC_791.IPv4.Address {

    static func octetTuple(_ octet1: UInt8, _ octet2: UInt8, _ octet3: UInt8, _ octet4: UInt8) -> Self {
        RFC_791.IPv4.Address(
            Byte(bitPattern: octet1),
            Byte(bitPattern: octet2),
            Byte(bitPattern: octet3),
            Byte(bitPattern: octet4)
        )
    }
}

func octetTuple(_ octet1: UInt8, _ octet2: UInt8, _ octet3: UInt8, _ octet4: UInt8) -> (Byte, Byte, Byte, Byte) {
    (
        Byte(bitPattern: octet1),
        Byte(bitPattern: octet2),
        Byte(bitPattern: octet3),
        Byte(bitPattern: octet4)
    )
}

func bytes(_ values: UInt8...) -> [Byte] {
    values.map(Byte.init(bitPattern:))
}
