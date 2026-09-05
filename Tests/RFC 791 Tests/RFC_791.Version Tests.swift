import RFC_791
import Testing

extension `RFC 791 Tests`.`Version Tests` {

    @Test
    func `accepts nibble values`() {
        #expect(RFC_791.Version(rawValue: 4)?.rawValue == 4)
        #expect(RFC_791.Version(rawValue: 15)?.rawValue == 15)
    }

    @Test
    func `rejects values above 15`() {
        #expect(RFC_791.Version(rawValue: 16) == nil)
        #expect(RFC_791.Version(rawValue: 255) == nil)
    }

    @Test
    func `names the IP versions`() {
        #expect(RFC_791.Version.v4.rawValue == 4)
        #expect(RFC_791.Version.v4.isIPv4)
        #expect(!RFC_791.Version.v4.isIPv6)
        #expect(RFC_791.Version.v6.rawValue == 6)
        #expect(RFC_791.Version.v6.isIPv6)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.Version.v4.description == "IPv4")
        #expect(RFC_791.Version.v6.description == "IPv6")
        #expect(RFC_791.Version(rawValue: 5)?.description == "Version(5)")
    }

    @Test
    func `orders versions numerically`() {
        #expect(RFC_791.Version.v4 < RFC_791.Version.v6)
    }
}
