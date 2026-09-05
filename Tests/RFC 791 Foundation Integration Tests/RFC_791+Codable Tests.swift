import Foundation
import RFC_791
import RFC_791_Foundation_Integration
import Testing

private typealias IPProtocol = RFC_791.`Protocol`

@Suite
struct `RFC 791 Foundation Integration Tests` {

    @Test
    func `an address codes as its dotted-decimal text`() throws {
        let address = try RFC_791.IPv4.Address("192.168.1.1")

        let encoded = try JSONEncoder().encode(address)

        #expect(String(decoding: encoded, as: UTF8.self) == #""192.168.1.1""#)
        #expect(try JSONDecoder().decode(RFC_791.IPv4.Address.self, from: encoded) == address)
    }

    @Test
    func `a malformed address fails to decode`() {
        let encoded = Data(#""256.0.0.1""#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.IPv4.Address.self, from: encoded)
        }
    }

    @Test
    func `an address class codes as its letter`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.IPv4.Address.Class.d)

        #expect(String(decoding: encoded, as: UTF8.self) == #""D""#)
        #expect(try JSONDecoder().decode(RFC_791.IPv4.Address.Class.self, from: encoded) == .d)
    }

    @Test
    func `a protocol codes as its number`() throws {
        let encoded = try JSONEncoder().encode(IPProtocol.tcp)

        #expect(String(decoding: encoded, as: UTF8.self) == "6")
        #expect(try JSONDecoder().decode(IPProtocol.self, from: encoded) == .tcp)
    }

    @Test
    func `a TTL codes as its number`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.TTL.default64)

        #expect(String(decoding: encoded, as: UTF8.self) == "64")
        #expect(try JSONDecoder().decode(RFC_791.TTL.self, from: encoded) == .default64)
    }

    @Test
    func `an identification codes as its number`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.Identification(rawValue: 0x1234))

        #expect(String(decoding: encoded, as: UTF8.self) == "4660")
        #expect(try JSONDecoder().decode(RFC_791.Identification.self, from: encoded).rawValue == 0x1234)
    }

    @Test
    func `a header checksum codes as its number`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.HeaderChecksum(rawValue: 0xB861))

        #expect(try JSONDecoder().decode(RFC_791.HeaderChecksum.self, from: encoded).rawValue == 0xB861)
    }

    @Test
    func `a version codes as its number and validates on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.Version.v4)

        #expect(String(decoding: encoded, as: UTF8.self) == "4")
        #expect(try JSONDecoder().decode(RFC_791.Version.self, from: encoded) == .v4)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.Version.self, from: Data("16".utf8))
        }
    }

    @Test
    func `an IHL codes as its word count and validates on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.IHL.minimum)

        #expect(String(decoding: encoded, as: UTF8.self) == "5")
        #expect(try JSONDecoder().decode(RFC_791.IHL.self, from: encoded) == .minimum)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.IHL.self, from: Data("3".utf8))
        }
    }

    @Test
    func `a type of service codes as its octet and validates on decode`() throws {
        let tos = RFC_791.TypeOfService(precedence: .flash, lowDelay: true)
        let encoded = try JSONEncoder().encode(tos)

        #expect(String(decoding: encoded, as: UTF8.self) == "112")
        #expect(try JSONDecoder().decode(RFC_791.TypeOfService.self, from: encoded) == tos)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.TypeOfService.self, from: Data("1".utf8))
        }
    }

    @Test
    func `a precedence codes as its level and validates on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.Precedence.flash)

        #expect(String(decoding: encoded, as: UTF8.self) == "3")
        #expect(try JSONDecoder().decode(RFC_791.Precedence.self, from: encoded) == .flash)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.Precedence.self, from: Data("8".utf8))
        }
    }

    @Test
    func `flags code as their bit pattern and validate on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.Flags.dontFragment)

        #expect(String(decoding: encoded, as: UTF8.self) == "2")
        #expect(try JSONDecoder().decode(RFC_791.Flags.self, from: encoded) == .dontFragment)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.Flags.self, from: Data("4".utf8))
        }
    }

    @Test
    func `a fragment offset codes as its unit count and validates on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.FragmentOffset(rawValue: 185)!)

        #expect(String(decoding: encoded, as: UTF8.self) == "185")
        #expect(try JSONDecoder().decode(RFC_791.FragmentOffset.self, from: encoded).rawValue == 185)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.FragmentOffset.self, from: Data("8192".utf8))
        }
    }

    @Test
    func `a total length codes as its byte count and validates on decode`() throws {
        let encoded = try JSONEncoder().encode(RFC_791.TotalLength.ethernetMTU)

        #expect(String(decoding: encoded, as: UTF8.self) == "1500")
        #expect(try JSONDecoder().decode(RFC_791.TotalLength.self, from: encoded) == .ethernetMTU)
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(RFC_791.TotalLength.self, from: Data("19".utf8))
        }
    }
}
