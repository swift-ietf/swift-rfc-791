import Foundation
import Testing

@testable import RFC_791

private typealias IPProtocol = RFC_791.`Protocol`

@Suite("RFC 791: Protocol Tests")
struct ProtocolTests {

    @Test
    func `Protocol from raw value`() {
        let proto = IPProtocol(rawValue: 6)
        #expect(proto.rawValue == 6)
        #expect(proto == .tcp)
    }

    @Test
    func `Protocol all values valid`() {

        for value: UInt8 in 0...255 {
            let proto = IPProtocol(rawValue: value)
            #expect(proto.rawValue == value)
        }
    }

    @Test
    func `Protocol static constants`() {
        #expect(IPProtocol.icmp.rawValue == 1)
        #expect(IPProtocol.igmp.rawValue == 2)
        #expect(IPProtocol.tcp.rawValue == 6)
        #expect(IPProtocol.udp.rawValue == 17)
        #expect(IPProtocol.ipv6.rawValue == 41)
        #expect(IPProtocol.gre.rawValue == 47)
        #expect(IPProtocol.esp.rawValue == 50)
        #expect(IPProtocol.ah.rawValue == 51)
        #expect(IPProtocol.icmpv6.rawValue == 58)
        #expect(IPProtocol.sctp.rawValue == 132)
    }

    @Test
    func `Protocol from bytes - valid`() throws {
        let proto = try IPProtocol(bytes: [Byte(bitPattern: 0x06)])
        #expect(proto == .tcp)
    }

    @Test
    func `Protocol from bytes - UDP`() throws {
        let proto = try IPProtocol(bytes: [Byte(bitPattern: 0x11)])
        #expect(proto == .udp)
    }

    @Test
    func `Protocol from bytes - empty`() {
        #expect(throws: IPProtocol.Error.self) {
            _ = try IPProtocol(bytes: [] as [Byte])
        }
    }

    @Test
    func `Protocol from bytes - multiple bytes (uses first)`() throws {

        let proto = try IPProtocol(bytes: ([0x06, 0x11, 0x01] as [UInt8]).map(Byte.init(bitPattern:)))
        #expect(proto == .tcp)
    }

    @Test
    func `Protocol serialization`() {
        let proto = IPProtocol.tcp
        var buffer: [Byte] = []
        proto.serialize(into: &buffer)
        #expect(buffer == ([0x06] as [UInt8]).map(Byte.init(bitPattern:)))
    }

    @Test
    func `Protocol bytes property`() {
        let proto = IPProtocol.udp
        #expect(proto.bytes == ([0x11] as [UInt8]).map(Byte.init(bitPattern:)))
    }

    @Test
    func `Protocol round trip`() throws {
        let original = IPProtocol.icmp
        let bytes = original.bytes
        let parsed = try IPProtocol(bytes: bytes)
        #expect(parsed == original)
    }

    @Test
    func `Protocol round trip all values`() throws {
        for value: UInt8 in 0...255 {
            let original = IPProtocol(rawValue: value)
            let bytes = original.bytes
            let parsed = try IPProtocol(bytes: bytes)
            #expect(parsed == original)
        }
    }

    @Test
    func `Protocol equality`() {
        let proto1 = IPProtocol.tcp
        let proto2 = IPProtocol(rawValue: 6)
        let proto3 = IPProtocol.udp

        #expect(proto1 == proto2)
        #expect(proto1 != proto3)
    }

    @Test
    func `Protocol hashable`() {
        var set: Set<IPProtocol> = []
        set.insert(.tcp)
        set.insert(.udp)
        set.insert(.tcp)

        #expect(set.count == 2)
        #expect(set.contains(.tcp))
        #expect(set.contains(.udp))
    }

    @Test
    func `Protocol description - known protocols`() {
        #expect(IPProtocol.icmp.description == "ICMP")
        #expect(IPProtocol.igmp.description == "IGMP")
        #expect(IPProtocol.tcp.description == "TCP")
        #expect(IPProtocol.udp.description == "UDP")
        #expect(IPProtocol.ipv6.description == "IPv6")
        #expect(IPProtocol.gre.description == "GRE")
        #expect(IPProtocol.esp.description == "ESP")
        #expect(IPProtocol.ah.description == "AH")
        #expect(IPProtocol.icmpv6.description == "ICMPv6")
        #expect(IPProtocol.sctp.description == "SCTP")
    }

    @Test
    func `Protocol description - unknown protocols`() {
        let proto = IPProtocol(rawValue: 99)
        #expect(proto.description == "Protocol(99)")

        let proto0 = IPProtocol(rawValue: 0)
        #expect(proto0.description == "Protocol(0)")
    }

    @Test
    func `Protocol codable`() throws {
        let original = IPProtocol.tcp

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(IPProtocol.self, from: data)

        #expect(decoded == original)
    }
}
