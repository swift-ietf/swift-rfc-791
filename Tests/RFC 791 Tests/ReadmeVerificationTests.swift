import Testing

@testable import RFC_791

private func address(
    _ octet1: UInt8,
    _ octet2: UInt8,
    _ octet3: UInt8,
    _ octet4: UInt8
) -> RFC_791.IPv4.Address {
    RFC_791.IPv4.Address(
        Byte(bitPattern: octet1),
        Byte(bitPattern: octet2),
        Byte(bitPattern: octet3),
        Byte(bitPattern: octet4)
    )
}

private func octets(
    _ octet1: UInt8,
    _ octet2: UInt8,
    _ octet3: UInt8,
    _ octet4: UInt8
) -> (Byte, Byte, Byte, Byte) {
    (
        Byte(bitPattern: octet1),
        Byte(bitPattern: octet2),
        Byte(bitPattern: octet3),
        Byte(bitPattern: octet4)
    )
}

private typealias IPProtocol = RFC_791.`Protocol`

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test
    func `Quick Start - Create IPv4 address`() {

        let address: RFC_791.IPv4.Address = "192.168.1.1"
        #expect(address.octets == octets(192, 168, 1, 1))
        #expect(address.class == .c)
    }

    @Test
    func `Quick Start - Header fields`() {

        let ttl = RFC_791.TTL.default64
        let proto = IPProtocol.tcp
        let flags = RFC_791.Flags(dontFragment: true, moreFragments: false)

        #expect(ttl.rawValue == 64)
        #expect(proto.rawValue == 6)
        #expect(flags.dontFragment == true)
        #expect(flags.moreFragments == false)
    }

    @Test
    func `Quick Start - Serialize to ASCII bytes`() {

        let address: RFC_791.IPv4.Address = "192.168.1.1"
        let text: [Byte] = address.serialized
        let wire: [Byte] = address.bytes

        #expect(String(decoding: text.map(\.bitPattern), as: UTF8.self) == "192.168.1.1")
        #expect(wire == ([192, 168, 1, 1] as [UInt8]).map(Byte.init(bitPattern:)))
    }

    @Test
    func `IPv4 Addresses - Creation methods`() {

        let addr1: RFC_791.IPv4.Address = "10.0.0.1"

        let addr2 = RFC_791.IPv4.Address(rawValue: 0xC0A8_0001)

        let addr3 = address(127, 0, 0, 1)

        #expect(addr1.octets == octets(10, 0, 0, 1))
        #expect(addr2.octets == octets(192, 168, 0, 1))
        #expect(addr3.octets == octets(127, 0, 0, 1))
    }

    @Test
    func `IPv4 Addresses - Access octets`() {
        let addr: RFC_791.IPv4.Address = "10.0.0.1"

        let (a, b, c, d) = addr.octets
        let description = "\(a.bitPattern).\(b.bitPattern).\(c.bitPattern).\(d.bitPattern)"

        #expect(description == "10.0.0.1")
    }

    @Test
    func `IPv4 Addresses - Classification`() {
        let addr: RFC_791.IPv4.Address = "10.0.0.1"

        #expect(addr.class == .a)
        #expect(addr.is.multicast == false)
        #expect(addr.is.reserved == false)
    }

    @Test
    func `IPv4 Addresses - Special addresses`() {

        #expect(RFC_791.IPv4.Address.any.rawValue == 0)
        #expect(RFC_791.IPv4.Address.broadcast.rawValue == 0xFFFF_FFFF)
        #expect(RFC_791.IPv4.Address.loopback.octets == octets(127, 0, 0, 1))
    }

    @Test
    func `Header Fields - Version`() {

        let version = RFC_791.Version.v4
        #expect(version.isIPv4 == true)
    }

    @Test
    func `Header Fields - IHL`() {

        let ihl = RFC_791.IHL.minimum
        #expect(ihl.byteLength == 20)
        #expect(ihl.hasOptions == false)
    }

    @Test
    func `Header Fields - TTL`() {

        let ttl = RFC_791.TTL(rawValue: 64)
        #expect(ttl.isExpired == false)
        #expect(ttl.decremented?.rawValue == 63)
    }

    @Test
    func `Header Fields - Protocol`() {

        #expect(IPProtocol.icmp.rawValue == 1)
        #expect(IPProtocol.tcp.rawValue == 6)
        #expect(IPProtocol.udp.rawValue == 17)
    }

    @Test
    func `Header Fields - Identification and TotalLength`() {

        let id = RFC_791.Identification(rawValue: 0x1234)
        #expect(id.rawValue == 0x1234)

        let length = RFC_791.TotalLength(rawValue: 1500)!
        #expect(length.maximumDataLength == 1480)
    }

    @Test
    func `Type of Service - Creation and components`() {

        let tos = RFC_791.TypeOfService(
            precedence: .immediate,
            lowDelay: true,
            highThroughput: false,
            highReliability: true
        )

        #expect(tos.precedence == .immediate)
        #expect(tos.lowDelay == true)
        #expect(tos.highThroughput == false)
        #expect(tos.highReliability == true)
    }

    @Test
    func `Type of Service - Precedence levels`() {

        #expect(RFC_791.Precedence.routine.rawValue == 0)
        #expect(RFC_791.Precedence.priority.rawValue == 1)
        #expect(RFC_791.Precedence.immediate.rawValue == 2)
        #expect(RFC_791.Precedence.flash.rawValue == 3)
        #expect(RFC_791.Precedence.flashOverride.rawValue == 4)
        #expect(RFC_791.Precedence.criticEcp.rawValue == 5)
        #expect(RFC_791.Precedence.internetworkControl.rawValue == 6)
        #expect(RFC_791.Precedence.networkControl.rawValue == 7)
    }

    @Test
    func `Fragmentation - Flags`() {

        let flags = RFC_791.Flags(dontFragment: false, moreFragments: true)
        #expect(flags.dontFragment == false)
        #expect(flags.moreFragments == true)
    }

    @Test
    func `Fragmentation - Fragment offset`() {

        let offset = RFC_791.FragmentOffset(rawValue: 185)!
        #expect(offset.byteOffset == 1480)
        #expect(offset.isFirstFragment == false)

        let firstFrag = RFC_791.FragmentOffset.fromByteOffset(0)!
        #expect(firstFrag.isFirstFragment == true)
    }

    @Test
    func `Header Checksum - Compute`() {

        let header: [Byte] = ([
            0x45, 0x00,
            0x00, 0x73,
            0x00, 0x00,
            0x40, 0x00,
            0x40, 0x11,
            0x00, 0x00,
            0xC0, 0xA8, 0x00, 0x01,
            0xC0, 0xA8, 0x00, 0xC7,
        ] as [UInt8]).map(Byte.init(bitPattern:))

        let checksum = RFC_791.HeaderChecksum.compute(over: header)
        #expect(checksum.rawValue == 0xB861)
    }

    @Test
    func `Header Checksum - Verify`() {

        let completeHeader: [Byte] = ([
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0xB8, 0x61,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7,
        ] as [UInt8]).map(Byte.init(bitPattern:))

        #expect(RFC_791.HeaderChecksum.verify(header: completeHeader) == true)
    }

    @Test
    func `Binary Serialization - 16-bit and 8-bit fields`() {
        var buffer: [Byte] = []

        RFC_791.TotalLength(rawValue: 1500)!.serialize(into: &buffer)
        #expect(buffer == ([0x05, 0xDC] as [UInt8]).map(Byte.init(bitPattern:)))

        RFC_791.Identification(rawValue: 0x1234).serialize(into: &buffer)
        RFC_791.HeaderChecksum(rawValue: 0xABCD).serialize(into: &buffer)

        RFC_791.TTL(rawValue: 64).serialize(into: &buffer)
        IPProtocol.tcp.serialize(into: &buffer)

        #expect(buffer.count == 8)
    }

    @Test
    func `Binary Serialization - Address to ASCII`() {

        let address: RFC_791.IPv4.Address = "192.168.1.1"
        let bytes: [Byte] = address.serialized

        #expect(String(decoding: bytes.map(\.bitPattern), as: UTF8.self) == "192.168.1.1")
    }

    @Test
    func `Binary Parsing - Address from ASCII`() throws {

        let addrBytes: [Byte] = "192.168.1.1".utf8.map(Byte.init(bitPattern:))
        let address = try RFC_791.IPv4.Address(ascii: addrBytes)
        #expect(address.octets == octets(192, 168, 1, 1))
    }

    @Test
    func `Binary Parsing - 16-bit fields`() throws {

        let lengthBytes: [Byte] = ([0x05, 0xDC] as [UInt8]).map(Byte.init(bitPattern:))
        let length = try RFC_791.TotalLength(bytes: lengthBytes)
        #expect(length.rawValue == 1500)
    }

    @Test
    func `Binary Parsing - Error handling`() {

        #expect(throws: RFC_791.TTL.Error.empty) {
            _ = try RFC_791.TTL(bytes: [] as [Byte])
        }
    }
}
