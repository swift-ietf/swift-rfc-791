import Testing

@testable import RFC_791

extension RFC_791.FragmentOffset {
    @Suite("RFC_791.FragmentOffset Tests")
    struct Test {

        @Test
        func `Valid fragment offset values (0-8191) are accepted`() {
            #expect(RFC_791.FragmentOffset(rawValue: 0)?.rawValue == 0)
            #expect(RFC_791.FragmentOffset(rawValue: 185)?.rawValue == 185)
            #expect(RFC_791.FragmentOffset(rawValue: 0x1FFF)?.rawValue == 8191)
        }

        @Test
        func `Invalid fragment offset values (>8191) are rejected`() {
            #expect(RFC_791.FragmentOffset(rawValue: 0x2000) == nil)
            #expect(RFC_791.FragmentOffset(rawValue: 0xFFFF) == nil)
        }

        @Test
        func `Zero offset constant`() {
            #expect(RFC_791.FragmentOffset.zero.rawValue == 0)
            #expect(RFC_791.FragmentOffset.zero.byteOffset == 0)
            #expect(RFC_791.FragmentOffset.zero.isFirstFragment)
        }

        @Test
        func `Maximum offset constant`() {
            #expect(RFC_791.FragmentOffset.maximum.rawValue == 8191)
            #expect(RFC_791.FragmentOffset.maximum.byteOffset == 65528)
        }

        @Test
        func `byteOffset calculation`() {
            #expect(RFC_791.FragmentOffset(rawValue: 0)?.byteOffset == 0)
            #expect(RFC_791.FragmentOffset(rawValue: 1)?.byteOffset == 8)

            #expect(RFC_791.FragmentOffset(rawValue: 185)?.byteOffset == 1480)
            #expect(RFC_791.FragmentOffset(rawValue: 8191)?.byteOffset == 65528)
        }

        @Test
        func `isFirstFragment property`() {
            #expect(RFC_791.FragmentOffset(rawValue: 0)?.isFirstFragment == true)
            #expect(RFC_791.FragmentOffset(rawValue: 1)?.isFirstFragment == false)
            #expect(RFC_791.FragmentOffset(rawValue: 185)?.isFirstFragment == false)
        }

        @Test
        func `Create from byte offset`() {
            #expect(RFC_791.FragmentOffset.fromByteOffset(0)?.rawValue == 0)
            #expect(RFC_791.FragmentOffset.fromByteOffset(8)?.rawValue == 1)
            #expect(RFC_791.FragmentOffset.fromByteOffset(1480)?.rawValue == 185)
            #expect(RFC_791.FragmentOffset.fromByteOffset(65528)?.rawValue == 8191)
        }

        @Test
        func `Create from invalid byte offset`() {
            #expect(RFC_791.FragmentOffset.fromByteOffset(-1) == nil)
            #expect(RFC_791.FragmentOffset.fromByteOffset(7) == nil)
            #expect(RFC_791.FragmentOffset.fromByteOffset(65536) == nil)
        }

        @Test
        func `Parse fragment offset from bytes`() throws {

            let bytes: [Byte] = ([0x00, 0xB9] as [UInt8]).map(Byte.init(bitPattern:))
            let offset = try RFC_791.FragmentOffset(bytes: bytes)
            #expect(offset.rawValue == 185)
        }

        @Test
        func `Parse with flags in upper bits`() throws {

            let bytes: [Byte] = ([0x40, 0xB9] as [UInt8]).map(Byte.init(bitPattern:))
            let offset = try RFC_791.FragmentOffset(bytes: bytes)
            #expect(offset.rawValue == 185)
        }

        @Test
        func `Parse maximum offset from bytes`() throws {
            let bytes: [Byte] = ([0x1F, 0xFF] as [UInt8]).map(Byte.init(bitPattern:))
            let offset = try RFC_791.FragmentOffset(bytes: bytes)
            #expect(offset.rawValue == 8191)
        }

        @Test
        func `Parse from empty bytes throws error`() {
            let bytes: [Byte] = []
            #expect(throws: RFC_791.FragmentOffset.Error.empty) {
                try RFC_791.FragmentOffset(bytes: bytes)
            }
        }

        @Test
        func `Parse from insufficient bytes throws error`() {
            let bytes: [Byte] = ([0x00] as [UInt8]).map(Byte.init(bitPattern:))
            #expect(throws: RFC_791.FragmentOffset.Error.insufficientBytes) {
                try RFC_791.FragmentOffset(bytes: bytes)
            }
        }

        @Test
        func `Serialize fragment offset to bytes`() {
            var buffer: [Byte] = []
            RFC_791.FragmentOffset(rawValue: 185)!.serialize(into: &buffer)
            #expect(buffer == ([0x00, 0xB9] as [UInt8]).map(Byte.init(bitPattern:)))
        }

        @Test
        func `Serialize maximum offset`() {
            var buffer: [Byte] = []
            RFC_791.FragmentOffset.maximum.serialize(into: &buffer)
            #expect(buffer == ([0x1F, 0xFF] as [UInt8]).map(Byte.init(bitPattern:)))
        }

        @Test
        func `Round-trip serialization`() throws {
            let original = RFC_791.FragmentOffset(rawValue: 370)!
            var buffer: [Byte] = []
            original.serialize(into: &buffer)

            let parsed = try RFC_791.FragmentOffset(bytes: buffer)
            #expect(parsed == original)
        }

        @Test
        func `Description format`() {
            let zeroDesc = RFC_791.FragmentOffset(rawValue: 0)?.description
            #expect(zeroDesc == "FragmentOffset(0 = 0 bytes)")
            let offset185Desc = RFC_791.FragmentOffset(rawValue: 185)?.description
            #expect(offset185Desc == "FragmentOffset(185 = 1480 bytes)")
        }

        @Test
        func `Fragment offsets are comparable`() {
            #expect(RFC_791.FragmentOffset.zero < RFC_791.FragmentOffset.maximum)
            #expect(RFC_791.FragmentOffset(rawValue: 100)! < RFC_791.FragmentOffset(rawValue: 200)!)
        }

        @Test
        func `Error descriptions`() {
            let emptyDesc = RFC_791.FragmentOffset.Error.empty.description
            #expect(emptyDesc == "FragmentOffset data cannot be empty")
            let insufficientDesc = RFC_791.FragmentOffset.Error.insufficientBytes.description
            #expect(insufficientDesc == "FragmentOffset requires 2 bytes")
        }
    }
}
