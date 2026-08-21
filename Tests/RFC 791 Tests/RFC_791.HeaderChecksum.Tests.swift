import Testing

@testable import RFC_791

extension RFC_791.HeaderChecksum {
    @Suite("RFC_791.HeaderChecksum Tests")
    struct Test {

        @Test
        func `All 16-bit values are valid checksums`() {
            #expect(RFC_791.HeaderChecksum(rawValue: 0).rawValue == 0)
            #expect(RFC_791.HeaderChecksum(rawValue: 0xFFFF).rawValue == 65535)
            #expect(RFC_791.HeaderChecksum(rawValue: 0xB861).rawValue == 0xB861)
        }

        @Test
        func `Zero constant`() {
            #expect(RFC_791.HeaderChecksum.zero.rawValue == 0)
        }

        @Test
        func `Compute checksum for simple header`() {

            let header: [Byte] = [
                0x45, 0x00,
                0x00, 0x73,
                0x00, 0x00,
                0x40, 0x00,
                0x40, 0x11,
                0x00, 0x00,
                0xC0, 0xA8, 0x00, 0x01,
                0xC0, 0xA8, 0x00, 0xC7,
            ]

            let checksum = RFC_791.HeaderChecksum.compute(over: header)
            #expect(checksum.rawValue == 0xB861)
        }

        @Test
        func `Verify valid checksum`() {

            let header: [Byte] = [
                0x45, 0x00,
                0x00, 0x73,
                0x00, 0x00,
                0x40, 0x00,
                0x40, 0x11,
                0xB8, 0x61,
                0xC0, 0xA8, 0x00, 0x01,
                0xC0, 0xA8, 0x00, 0xC7,
            ]

            #expect(RFC_791.HeaderChecksum.verify(header: header))
        }

        @Test
        func `Verify invalid checksum`() {
            let header: [Byte] = [
                0x45, 0x00,
                0x00, 0x73,
                0x00, 0x00,
                0x40, 0x00,
                0x40, 0x11,
                0x00, 0x00,
                0xC0, 0xA8, 0x00, 0x01,
                0xC0, 0xA8, 0x00, 0xC7,
            ]

            #expect(!RFC_791.HeaderChecksum.verify(header: header))
        }

        @Test
        func `Compute checksum for all zeros`() {
            let header: [Byte] = Array(repeating: 0, count: 20)
            let checksum = RFC_791.HeaderChecksum.compute(over: header)
            #expect(checksum.rawValue == 0xFFFF)
        }

        @Test
        func `Compute checksum for all ones`() {
            var header: [Byte] = Array(repeating: 0xFF, count: 20)

            header[10] = 0
            header[11] = 0
            let checksum = RFC_791.HeaderChecksum.compute(over: header)

            #expect(checksum.rawValue == 0x0000)
        }

        @Test
        func `Parse checksum from bytes (big-endian)`() throws {
            let bytes: [Byte] = [0xB8, 0x61]
            let checksum = try RFC_791.HeaderChecksum(bytes: bytes)
            #expect(checksum.rawValue == 0xB861)
        }

        @Test
        func `Parse from empty bytes throws error`() {
            let bytes: [Byte] = []
            #expect(throws: RFC_791.HeaderChecksum.Error.empty) {
                try RFC_791.HeaderChecksum(bytes: bytes)
            }
        }

        @Test
        func `Parse from insufficient bytes throws error`() {
            let bytes: [Byte] = [0xB8]
            #expect(throws: RFC_791.HeaderChecksum.Error.insufficientBytes) {
                try RFC_791.HeaderChecksum(bytes: bytes)
            }
        }

        @Test
        func `Serialize checksum to bytes (big-endian)`() {
            var buffer: [Byte] = []
            RFC_791.HeaderChecksum(rawValue: 0xB861).serialize(into: &buffer)
            #expect(buffer == [0xB8, 0x61])
        }

        @Test
        func `Round-trip serialization`() throws {
            let original = RFC_791.HeaderChecksum(rawValue: 0x1234)
            var buffer: [Byte] = []
            original.serialize(into: &buffer)

            let parsed = try RFC_791.HeaderChecksum(bytes: buffer)
            #expect(parsed == original)
        }

        @Test
        func `Description format (hexadecimal)`() {
            #expect(RFC_791.HeaderChecksum(rawValue: 0xB861).description == "0xB861")
            #expect(RFC_791.HeaderChecksum(rawValue: 0x0001).description == "0x1")
            #expect(RFC_791.HeaderChecksum(rawValue: 0xFFFF).description == "0xFFFF")
        }

        @Test
        func `Error descriptions`() {
            let emptyDesc = RFC_791.HeaderChecksum.Error.empty.description
            #expect(emptyDesc == "HeaderChecksum data cannot be empty")
            let insufficientDesc = RFC_791.HeaderChecksum.Error.insufficientBytes.description
            #expect(insufficientDesc == "HeaderChecksum requires 2 bytes")
        }
    }
}
