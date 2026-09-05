import Byte
import RFC_791
import Testing

extension `RFC 791 Tests`.`IPv4 Address Tests` {

    @Test
    func `builds an address from four octets`() {
        let address = RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1)
        #expect(address.octets == octetTuple(192, 168, 1, 1))
        #expect(address.rawValue == 0xC0A8_0101)
    }

    @Test
    func `builds an address from its raw value`() {
        let address = RFC_791.IPv4.Address(rawValue: 0xC0A8_0101)
        #expect(address.octets == octetTuple(192, 168, 1, 1))
    }

    @Test
    func `projects the raw value in network byte order`() {
        let address = RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1)
        #expect(UInt32(bigEndian: address.bigEndian) == 0xC0A8_0101)
        withUnsafeBytes(of: address.bigEndian) { bytes in
            #expect(unsafe bytes[0] == 192)
            #expect(unsafe bytes[1] == 168)
            #expect(unsafe bytes[2] == 1)
            #expect(unsafe bytes[3] == 1)
        }
    }

    @Test
    func `validates dotted-decimal text`() throws {
        #expect(try RFC_791.IPv4.Address("192.168.1.1").octets == octetTuple(192, 168, 1, 1))
        #expect(try RFC_791.IPv4.Address("0.0.0.0").rawValue == 0)
        #expect(try RFC_791.IPv4.Address("255.255.255.255").rawValue == 0xFFFF_FFFF)
        #expect(try RFC_791.IPv4.Address("127.0.0.1") == .loopback)
    }

    @Test
    func `validates dotted-decimal ASCII bytes`() throws {
        let address = try RFC_791.IPv4.Address(ascii: "172.16.0.1".utf8.map(Byte.init(bitPattern:)))
        #expect(address.octets == octetTuple(172, 16, 0, 1))
    }

    @Test
    func `rejects text with the wrong number of octets`() {
        #expect(throws: RFC_791.IPv4.Address.Error.invalidFormat("192.168.1")) {
            try RFC_791.IPv4.Address("192.168.1")
        }
        #expect(throws: RFC_791.IPv4.Address.Error.invalidFormat("192.168.1.1.1")) {
            try RFC_791.IPv4.Address("192.168.1.1.1")
        }
    }

    @Test
    func `rejects an octet above 255`() {
        #expect(throws: RFC_791.IPv4.Address.Error.octetOutOfRange(256, position: 0)) {
            try RFC_791.IPv4.Address("256.0.0.1")
        }
        #expect(throws: RFC_791.IPv4.Address.Error.octetOutOfRange(300, position: 3)) {
            try RFC_791.IPv4.Address("192.168.1.300")
        }
    }

    @Test
    func `rejects a leading zero`() {
        #expect(throws: RFC_791.IPv4.Address.Error.leadingZero("192.168.01.1", position: 2)) {
            try RFC_791.IPv4.Address("192.168.01.1")
        }
    }

    @Test
    func `rejects non-digit characters`() {
        #expect(throws: RFC_791.IPv4.Address.Error.self) {
            try RFC_791.IPv4.Address("not.an.ip.address")
        }
        #expect(throws: RFC_791.IPv4.Address.Error.self) {
            try RFC_791.IPv4.Address("-1.0.0.1")
        }
    }

    @Test
    func `rejects empty text`() {
        #expect(throws: RFC_791.IPv4.Address.Error.empty) {
            try RFC_791.IPv4.Address("")
        }
    }

    @Test
    func `describes itself in dotted-decimal`() throws {
        #expect(RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1).description == "192.168.1.1")
        #expect(RFC_791.IPv4.Address.any.description == "0.0.0.0")
        #expect(RFC_791.IPv4.Address.broadcast.description == "255.255.255.255")
        #expect(RFC_791.IPv4.Address.loopback.description == "127.0.0.1")
    }

    @Test
    func `round-trips through its text form`() throws {
        let text = "10.0.0.255"
        #expect(try RFC_791.IPv4.Address(text).description == text)
    }

    @Test
    func `orders addresses by their raw value`() {
        let addresses = [
            RFC_791.IPv4.Address.octetTuple(192, 168, 1, 100),
            RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1),
            RFC_791.IPv4.Address.octetTuple(192, 168, 1, 50),
            RFC_791.IPv4.Address.octetTuple(10, 0, 0, 1),
        ]

        #expect(
            addresses.sorted().map(\.description) == [
                "10.0.0.1", "192.168.1.1", "192.168.1.50", "192.168.1.100",
            ]
        )
    }

    @Test
    func `is hashable by value`() {
        let set: Set<RFC_791.IPv4.Address> = [
            .octetTuple(192, 168, 1, 1),
            .octetTuple(192, 168, 1, 1),
            .octetTuple(192, 168, 1, 2),
        ]
        #expect(set.count == 2)
    }

    @Test
    func `names the special addresses`() {
        #expect(RFC_791.IPv4.Address.any.rawValue == 0)
        #expect(RFC_791.IPv4.Address.broadcast.rawValue == 0xFFFF_FFFF)
        #expect(RFC_791.IPv4.Address.loopback.octets == octetTuple(127, 0, 0, 1))
    }

    @Test
    func `describes its errors`() {
        #expect(RFC_791.IPv4.Address.Error.empty.description == "IPv4 address cannot be empty")
        #expect(
            RFC_791.IPv4.Address.Error.octetOutOfRange(256, position: 0).description
                == "Octet 1 value 256 is out of range (must be 0-255)"
        )
    }
}
