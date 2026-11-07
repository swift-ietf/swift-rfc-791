import RFC_791
import Testing

extension `RFC 791 Tests`.`Fragment Offset Tests` {

    @Test
    func `accepts 13-bit values`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0)?.rawValue == 0)
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.rawValue == 185)
        #expect(RFC_791.FragmentOffset(rawValue: 0x1FFF)?.rawValue == 8191)
    }

    @Test
    func `rejects values above 13 bits`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0x2000) == nil)
        #expect(RFC_791.FragmentOffset(rawValue: 0xFFFF) == nil)
    }

    @Test
    func `names the bounds`() {
        #expect(RFC_791.FragmentOffset.zero.rawValue == 0)
        #expect(RFC_791.FragmentOffset.zero.isFirstFragment)
        #expect(RFC_791.FragmentOffset.maximum.rawValue == 8191)
        #expect(RFC_791.FragmentOffset.maximum.byteOffset == 65528)
    }

    @Test
    func `measures the offset in 8-octet units`() {
        #expect(RFC_791.FragmentOffset(rawValue: 1)?.byteOffset == 8)
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.byteOffset == 1480)
    }

    @Test
    func `reports the first fragment`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0)?.isFirstFragment == true)
        #expect(RFC_791.FragmentOffset(rawValue: 1)?.isFirstFragment == false)
    }

    @Test
    func `derives the offset from an aligned byte offset`() {
        #expect(RFC_791.FragmentOffset.fromByteOffset(0)?.rawValue == 0)
        #expect(RFC_791.FragmentOffset.fromByteOffset(8)?.rawValue == 1)
        #expect(RFC_791.FragmentOffset.fromByteOffset(1480)?.rawValue == 185)
        #expect(RFC_791.FragmentOffset.fromByteOffset(65528)?.rawValue == 8191)
    }

    @Test
    func `rejects byte offsets that are negative, unaligned or too large`() {
        #expect(RFC_791.FragmentOffset.fromByteOffset(-1) == nil)
        #expect(RFC_791.FragmentOffset.fromByteOffset(7) == nil)
        #expect(RFC_791.FragmentOffset.fromByteOffset(65536) == nil)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.FragmentOffset.zero.description == "FragmentOffset(0 = 0 bytes)")
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.description == "FragmentOffset(185 = 1480 bytes)")
    }

    @Test
    func `orders offsets numerically`() {
        #expect(RFC_791.FragmentOffset.zero < RFC_791.FragmentOffset.maximum)
        #expect(RFC_791.FragmentOffset(rawValue: 100)! < RFC_791.FragmentOffset(rawValue: 200)!)
    }
}
