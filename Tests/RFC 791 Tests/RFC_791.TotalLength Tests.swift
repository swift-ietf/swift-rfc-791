import RFC_791
import Testing

extension `RFC 791 Tests`.`Total Length Tests` {

    @Test
    func `accepts 20 through 65535 bytes`() {
        #expect(RFC_791.TotalLength(rawValue: 20)?.rawValue == 20)
        #expect(RFC_791.TotalLength(rawValue: 576)?.rawValue == 576)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.rawValue == 1500)
        #expect(RFC_791.TotalLength(rawValue: 65535)?.rawValue == 65535)
    }

    @Test
    func `rejects lengths shorter than a minimal header`() {
        for value: UInt16 in 0..<20 {
            #expect(RFC_791.TotalLength(rawValue: value) == nil)
        }
    }

    @Test
    func `names the well-known lengths`() {
        #expect(RFC_791.TotalLength.minimum.rawValue == 20)
        #expect(RFC_791.TotalLength.minimum.isMinimum)
        #expect(RFC_791.TotalLength.maximum.rawValue == 65535)
        #expect(RFC_791.TotalLength.minimumReassemblyBuffer.rawValue == 576)
        #expect(RFC_791.TotalLength.ethernetMTU.rawValue == 1500)
    }

    @Test
    func `derives the maximum data length`() {
        #expect(RFC_791.TotalLength(rawValue: 20)?.maximumDataLength == 0)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.maximumDataLength == 1480)
        #expect(RFC_791.TotalLength(rawValue: 65535)?.maximumDataLength == 65515)
    }

    @Test
    func `reports whether it is the minimum`() {
        #expect(RFC_791.TotalLength(rawValue: 21)?.isMinimum == false)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.TotalLength(rawValue: 1500)?.description == "1500 bytes")
    }

    @Test
    func `orders lengths numerically`() {
        #expect(RFC_791.TotalLength.minimum < RFC_791.TotalLength.ethernetMTU)
        #expect(RFC_791.TotalLength.ethernetMTU < RFC_791.TotalLength.maximum)
    }
}
