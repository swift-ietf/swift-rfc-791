import Testing

@testable import RFC_791

extension RFC_791.IPv4.Address {
    @Suite("RFC 791: IPv4 Address Tests")
    struct Test {

        @Test
        func `IPv4 Address from octets`() throws {
            let address = RFC_791.IPv4.Address(192, 168, 1, 1)

            #expect(address.octets.0 == 192)
            #expect(address.octets.1 == 168)
            #expect(address.octets.2 == 1)
            #expect(address.octets.3 == 1)
        }

        @Test
        func `IPv4 Address from raw value`() throws {

            let address = RFC_791.IPv4.Address(rawValue: 0xC0A8_0101)

            let (a, b, c, d) = address.octets
            #expect(a == 192)
            #expect(b == 168)
            #expect(c == 1)
            #expect(d == 1)
        }

        @Test
        func `IPv4 Address network byte order projection`() throws {

            let address = RFC_791.IPv4.Address(192, 168, 1, 1)

            #expect(UInt32(bigEndian: address.bigEndian) == 0xC0A8_0101)
            withUnsafeBytes(of: address.bigEndian) { bytes in
                #expect(bytes[0] == 192)
                #expect(bytes[1] == 168)
                #expect(bytes[2] == 1)
                #expect(bytes[3] == 1)
            }
        }

        @Test
        func `IPv4 Address from string - valid`() throws {
            let address: RFC_791.IPv4.Address = try .init("192.168.1.1")

            #expect(address.octets.0 == 192)
            #expect(address.octets.1 == 168)
            #expect(address.octets.2 == 1)
            #expect(address.octets.3 == 1)
        }

        @Test
        func `IPv4 Address from string - edge cases`() throws {

            let zeros: RFC_791.IPv4.Address = try .init("0.0.0.0")
            #expect(zeros.rawValue == 0)

            let broadcast: RFC_791.IPv4.Address = try .init("255.255.255.255")
            #expect(broadcast.rawValue == 0xFFFF_FFFF)

            let localhost: RFC_791.IPv4.Address = try .init("127.0.0.1")
            #expect(localhost.octets.0 == 127)
            #expect(localhost.octets.3 == 1)
        }

        @Test
        func `IPv4 Address from string - invalid format`() throws {
            let invalid1 = "192.168.1"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(invalid1)
            }

            let invalid2 = "192.168.1.1.1"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(invalid2)
            }

            let invalid3 = "not.an.ip.address"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(invalid3)
            }
        }

        @Test
        func `IPv4 Address from string - out of range`() throws {
            let outOfRange1 = "256.0.0.1"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(outOfRange1)
            }

            let outOfRange2 = "192.168.1.300"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(outOfRange2)
            }

            let outOfRange3 = "-1.0.0.1"
            #expect(throws: RFC_791.IPv4.Address.Error.self) {
                let _: RFC_791.IPv4.Address = try .init(outOfRange3)
            }
        }

        @Test
        func `IPv4 Address from string literal`() throws {
            let address: RFC_791.IPv4.Address = "192.168.1.1"
            #expect(address.description == "192.168.1.1")
        }

        @Test
        func `IPv4 Address description`() throws {
            let address = RFC_791.IPv4.Address(192, 168, 1, 1)
            #expect(address.description == "192.168.1.1")

            let zeros = RFC_791.IPv4.Address(0, 0, 0, 0)
            #expect(zeros.description == "0.0.0.0")

            let broadcast = RFC_791.IPv4.Address(255, 255, 255, 255)
            #expect(broadcast.description == "255.255.255.255")
        }

        @Test
        func `IPv4 Address round-trip through string`() throws {
            let original = "192.168.1.1"
            let address: RFC_791.IPv4.Address = try .init(original)
            let serialized = address.description

            #expect(serialized == original)
        }

        @Test
        func `IPv4 Address equality`() throws {
            let addr1 = RFC_791.IPv4.Address(192, 168, 1, 1)
            let addr2 = RFC_791.IPv4.Address(192, 168, 1, 1)
            let addr3 = RFC_791.IPv4.Address(192, 168, 1, 2)

            #expect(addr1 == addr2)
            #expect(addr1 != addr3)
        }

        @Test
        func `IPv4 Address hashable`() throws {
            let addr1 = RFC_791.IPv4.Address(192, 168, 1, 1)
            let addr2 = RFC_791.IPv4.Address(192, 168, 1, 1)
            let addr3 = RFC_791.IPv4.Address(192, 168, 1, 2)

            var set: Set<RFC_791.IPv4.Address> = []
            set.insert(addr1)
            set.insert(addr2)
            set.insert(addr3)

            #expect(set.count == 2)
            #expect(set.contains(addr1))
            #expect(set.contains(addr3))
        }

        @Test
        func `IPv4 Address comparable`() throws {
            let addr1 = RFC_791.IPv4.Address(192, 168, 1, 1)
            let addr2 = RFC_791.IPv4.Address(192, 168, 1, 10)
            let addr3 = RFC_791.IPv4.Address(192, 168, 2, 1)

            #expect(addr1 < addr2)
            #expect(addr2 < addr3)
            #expect(addr1 < addr3)
        }

        @Test
        func `IPv4 Address sorting`() throws {
            let addresses = [
                RFC_791.IPv4.Address(192, 168, 1, 100),
                RFC_791.IPv4.Address(192, 168, 1, 1),
                RFC_791.IPv4.Address(192, 168, 1, 50),
                RFC_791.IPv4.Address(10, 0, 0, 1),
            ]

            let sorted = addresses.sorted()

            #expect(sorted[0].description == "10.0.0.1")
            #expect(sorted[1].description == "192.168.1.1")
            #expect(sorted[2].description == "192.168.1.50")
            #expect(sorted[3].description == "192.168.1.100")
        }

        @Test
        func `IPv4 Address range operations`() throws {
            let start = RFC_791.IPv4.Address(192, 168, 1, 1)
            let end = RFC_791.IPv4.Address(192, 168, 1, 255)
            let inRange = RFC_791.IPv4.Address(192, 168, 1, 100)
            let outOfRange = RFC_791.IPv4.Address(192, 168, 2, 1)

            #expect(inRange >= start)
            #expect(inRange <= end)
            #expect(outOfRange > end)
        }

        @Test
        func `IPv4 Address special addresses`() throws {

            let loopback = RFC_791.IPv4.Address(127, 0, 0, 1)
            #expect(loopback.description == "127.0.0.1")

            let broadcast = RFC_791.IPv4.Address(255, 255, 255, 255)
            #expect(broadcast.description == "255.255.255.255")

            let unspecified = RFC_791.IPv4.Address(0, 0, 0, 0)
            #expect(unspecified.description == "0.0.0.0")

            let private1 = RFC_791.IPv4.Address(10, 0, 0, 1)
            #expect(private1.description == "10.0.0.1")

            let private2 = RFC_791.IPv4.Address(172, 16, 0, 1)
            #expect(private2.description == "172.16.0.1")

            let private3 = RFC_791.IPv4.Address(192, 168, 0, 1)
            #expect(private3.description == "192.168.0.1")
        }

        @Test
        func `IPv4 Address raw value consistency`() throws {
            let address = RFC_791.IPv4.Address(192, 168, 1, 1)
            let fromRaw = RFC_791.IPv4.Address(rawValue: address.rawValue)

            #expect(address == fromRaw)
            #expect(address.octets == fromRaw.octets)
        }

        @Test
        func `IPv4 Address octet extraction`() throws {
            let address = RFC_791.IPv4.Address(rawValue: 0xC0A8_0101)
            let (a, b, c, d) = address.octets

            #expect(a == 0xC0)
            #expect(b == 0xA8)
            #expect(c == 0x01)
            #expect(d == 0x01)
        }

        @Test
        func `Binary.Serializable wire form is four network-order octets`() {
            let address = RFC_791.IPv4.Address(192, 168, 1, 1)
            #expect(address.bytes == [192, 168, 1, 1])
        }

        @Test
        func `ASCII.Serializable text form is dotted-decimal`() {
            let address = RFC_791.IPv4.Address(192, 168, 1, 1)
            #expect(String(decoding: address.serialized.underlying, as: UTF8.self) == "192.168.1.1")
        }

        @Test
        func `the two format siblings are distinct representations`() {

            let address: RFC_791.IPv4.Address = "10.0.0.255"
            #expect(String(decoding: address.serialized.underlying, as: UTF8.self) == "10.0.0.255")
            #expect(address.bytes == [10, 0, 0, 255])
        }

        @Test
        func `Binary.Parseable round-trips the wire form with cursor semantics`() throws {
            var source: [Byte] = [192, 168, 1, 1, 0xFF]
            let address = try RFC_791.IPv4.Address.parse(from: &source)
            #expect(address == RFC_791.IPv4.Address(192, 168, 1, 1))
            #expect(source == [0xFF])
        }

        @Test
        func `Binary.Parseable rejects insufficient input`() {
            var source: [Byte] = [192, 168, 1]
            #expect(throws: (any Swift.Error).self) {
                _ = try RFC_791.IPv4.Address.parse(from: &source)
            }
        }

        @Test
        func `ASCII.Parseable round-trips the text form`() throws {
            let address = try RFC_791.IPv4.Address(ascii: Array("172.16.0.1".utf8))
            #expect(address.octets == (172, 16, 0, 1))
            #expect(String(decoding: address.serialized.underlying, as: UTF8.self) == "172.16.0.1")
        }
    }
}
