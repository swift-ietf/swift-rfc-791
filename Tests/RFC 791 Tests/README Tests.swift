import Byte
import RFC_791
import Testing

private typealias IPProtocol = RFC_791.`Protocol`

@Suite
struct `README Tests` {

    @Test
    func `Quick Start`() throws {
        let address = try RFC_791.IPv4.Address("192.168.1.1")
        #expect(address.octets == octetTuple(192, 168, 1, 1))
        #expect(address.class == .c)
        #expect(address.description == "192.168.1.1")

        let ttl = RFC_791.TTL.default64
        let proto = IPProtocol.tcp
        let flags = RFC_791.Flags(dontFragment: true, moreFragments: false)

        #expect(ttl.rawValue == 64)
        #expect(proto.rawValue == 6)
        #expect(flags.dontFragment)
        #expect(!flags.moreFragments)
    }

    @Test
    func `IPv4 addresses`() throws {
        let fromText = try RFC_791.IPv4.Address("10.0.0.1")
        let fromRawValue = RFC_791.IPv4.Address(rawValue: 0xC0A8_0001)
        let fromOctets = RFC_791.IPv4.Address(
            Byte(bitPattern: 127), Byte(bitPattern: 0), Byte(bitPattern: 0), Byte(bitPattern: 1)
        )

        #expect(fromText.octets == octetTuple(10, 0, 0, 1))
        #expect(fromRawValue.description == "192.168.0.1")
        #expect(fromOctets == .loopback)

        #expect(fromText.class == .a)
        #expect(!fromText.is.multicast)
        #expect(!fromText.is.reserved)

        #expect(RFC_791.IPv4.Address.any.description == "0.0.0.0")
        #expect(RFC_791.IPv4.Address.broadcast.description == "255.255.255.255")
        #expect(RFC_791.IPv4.Address.loopback.description == "127.0.0.1")
    }

    @Test
    func `IP header fields`() {
        #expect(RFC_791.Version.v4.isIPv4)

        let ihl = RFC_791.IHL.minimum
        #expect(ihl.byteLength == 20)
        #expect(!ihl.hasOptions)

        let ttl = RFC_791.TTL(rawValue: 64)
        #expect(!ttl.isExpired)
        #expect(ttl.decremented?.rawValue == 63)

        #expect(IPProtocol.icmp.rawValue == 1)
        #expect(IPProtocol.tcp.rawValue == 6)
        #expect(IPProtocol.udp.rawValue == 17)

        #expect(RFC_791.Identification(rawValue: 0x1234).rawValue == 0x1234)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.maximumDataLength == 1480)
    }

    @Test
    func `Type of Service`() {
        let tos = RFC_791.TypeOfService(
            precedence: .immediate,
            lowDelay: true,
            highThroughput: false,
            highReliability: true
        )

        #expect(tos.precedence == .immediate)
        #expect(tos.lowDelay)
        #expect(!tos.highThroughput)
        #expect(tos.highReliability)

        #expect(RFC_791.Precedence.routine.rawValue == 0)
        #expect(RFC_791.Precedence.networkControl.rawValue == 7)
    }

    @Test
    func `Fragmentation`() {
        let flags = RFC_791.Flags(dontFragment: false, moreFragments: true)
        #expect(!flags.dontFragment)
        #expect(flags.moreFragments)

        let offset = RFC_791.FragmentOffset(rawValue: 185)!
        #expect(offset.byteOffset == 1480)
        #expect(!offset.isFirstFragment)

        #expect(RFC_791.FragmentOffset.fromByteOffset(0)?.isFirstFragment == true)
    }

    @Test
    func `Header checksum`() {
        let header = bytes(
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0x00, 0x00,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7
        )
        #expect(RFC_791.HeaderChecksum.compute(over: header).rawValue == 0xB861)

        let complete = bytes(
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0xB8, 0x61,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7
        )
        #expect(RFC_791.HeaderChecksum.verify(header: complete))
    }
}
