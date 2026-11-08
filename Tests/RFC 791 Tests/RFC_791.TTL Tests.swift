import RFC_791
import Testing

extension `RFC 791 Tests`.`TTL Tests` {

    @Test
    func `accepts every 8-bit value`() {
        for value: UInt8 in 0...255 {
            #expect(RFC_791.TTL(rawValue: value).rawValue == value)
        }
    }

    @Test
    func `names the conventional values`() {
        #expect(RFC_791.TTL.default64.rawValue == 64)
        #expect(RFC_791.TTL.default128.rawValue == 128)
        #expect(RFC_791.TTL.maximum.rawValue == 255)
        #expect(RFC_791.TTL.expired.rawValue == 0)
        #expect(RFC_791.TTL.linkLocal.rawValue == 1)
    }

    @Test
    func `expires at zero`() {
        #expect(RFC_791.TTL.expired.isExpired)
        #expect(!RFC_791.TTL(rawValue: 1).isExpired)
        #expect(!RFC_791.TTL.maximum.isExpired)
    }

    @Test
    func `decrements until it expires`() {
        #expect(RFC_791.TTL(rawValue: 64).decremented?.rawValue == 63)
        #expect(RFC_791.TTL(rawValue: 1).decremented == .expired)
        #expect(RFC_791.TTL.expired.decremented == nil)
    }

    @Test
    func `counts the hops of a decrement chain`() {
        var ttl: RFC_791.TTL? = RFC_791.TTL(rawValue: 5)
        var hops = 0
        while let current = ttl {
            ttl = current.decremented
            hops += 1
        }
        #expect(hops == 6)
    }

    @Test
    func `is expressible by an integer literal`() {
        let ttl: RFC_791.TTL = 64
        #expect(ttl == .default64)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.TTL.default64.description == "TTL(64)")
        #expect(RFC_791.TTL.expired.description == "TTL(0)")
    }

    @Test
    func `orders TTLs numerically`() {
        #expect(RFC_791.TTL.expired < RFC_791.TTL.default64)
        #expect(RFC_791.TTL.default64 < RFC_791.TTL.maximum)
    }
}
