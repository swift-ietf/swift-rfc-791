import Byte
import RFC_791
import Testing

extension `RFC 791 Tests`.`Header Checksum Tests` {

    @Test
    func `accepts every 16-bit value`() {
        #expect(RFC_791.HeaderChecksum(rawValue: 0).rawValue == 0)
        #expect(RFC_791.HeaderChecksum(rawValue: 0xB861).rawValue == 0xB861)
        #expect(RFC_791.HeaderChecksum(rawValue: 0xFFFF).rawValue == 65535)
        #expect(RFC_791.HeaderChecksum.zero.rawValue == 0)
    }

    @Test
    func `computes the one's complement checksum of a header`() {
        let header = bytes(
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0x00, 0x00,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7
        )
        #expect(RFC_791.HeaderChecksum.compute(over: header).rawValue == 0xB861)
    }

    @Test
    func `verifies a header carrying its checksum`() {
        let header = bytes(
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0xB8, 0x61,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7
        )
        #expect(RFC_791.HeaderChecksum.verify(header: header))
    }

    @Test
    func `rejects a header with a zeroed checksum`() {
        let header = bytes(
            0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
            0x40, 0x11, 0x00, 0x00,
            0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7
        )
        #expect(!RFC_791.HeaderChecksum.verify(header: header))
    }

    @Test
    func `checksums all zeros to all ones`() {
        let header = [Byte](repeating: Byte(bitPattern: 0), count: 20)
        #expect(RFC_791.HeaderChecksum.compute(over: header).rawValue == 0xFFFF)
    }

    @Test
    func `checksums all ones to zero`() {
        var header = [Byte](repeating: Byte(bitPattern: 0xFF), count: 20)
        header[10] = Byte(bitPattern: 0)
        header[11] = Byte(bitPattern: 0)
        #expect(RFC_791.HeaderChecksum.compute(over: header).rawValue == 0)
    }

    @Test
    func `describes itself in hexadecimal`() {
        #expect(RFC_791.HeaderChecksum(rawValue: 0xB861).description == "0xB861")
        #expect(RFC_791.HeaderChecksum(rawValue: 0x0001).description == "0x1")
    }
}
