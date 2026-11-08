import RFC_791
import Testing

private typealias IPProtocol = RFC_791.`Protocol`

extension `RFC 791 Tests`.`Protocol Tests` {

    @Test
    func `accepts every 8-bit protocol number`() {
        for value: UInt8 in 0...255 {
            #expect(IPProtocol(rawValue: value).rawValue == value)
        }
    }

    @Test
    func `names the assigned protocol numbers`() {
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
    func `is equatable and hashable by value`() {
        #expect(IPProtocol(rawValue: 6) == .tcp)
        let set: Set<IPProtocol> = [.tcp, .udp, .tcp]
        #expect(set.count == 2)
    }

    @Test
    func `describes the assigned protocols by name`() {
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
    func `describes unassigned protocols by number`() {
        #expect(IPProtocol(rawValue: 99).description == "Protocol(99)")
        #expect(IPProtocol(rawValue: 0).description == "Protocol(0)")
    }
}
