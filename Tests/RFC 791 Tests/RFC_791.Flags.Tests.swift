import Testing

@testable import RFC_791

extension RFC_791.Flags {
    @Suite("RFC 791: Flags Tests")
    struct Test {

        @Test
        func `Flags from raw value - valid`() {

            let flags = RFC_791.Flags(rawValue: 0b011)
            #expect(flags != nil)
            #expect(flags?.dontFragment == true)
            #expect(flags?.moreFragments == true)
        }

        @Test
        func `Flags from raw value - invalid (reserved bit set)`() {

            #expect(RFC_791.Flags(rawValue: 0b100) == nil)
            #expect(RFC_791.Flags(rawValue: 0b111) == nil)
        }

        @Test
        func `Flags from components`() {
            let flags = RFC_791.Flags(dontFragment: true, moreFragments: false)

            #expect(flags.dontFragment == true)
            #expect(flags.moreFragments == false)
        }

        @Test
        func `Flags default values`() {
            let flags = RFC_791.Flags()

            #expect(flags.dontFragment == false)
            #expect(flags.moreFragments == false)
        }

        @Test
        func `Flags individual flag access`() {

            let df = RFC_791.Flags(dontFragment: true, moreFragments: false)
            #expect(df.dontFragment == true)
            #expect(df.moreFragments == false)

            let mf = RFC_791.Flags(dontFragment: false, moreFragments: true)
            #expect(mf.dontFragment == false)
            #expect(mf.moreFragments == true)

            let both = RFC_791.Flags(dontFragment: true, moreFragments: true)
            #expect(both.dontFragment == true)
            #expect(both.moreFragments == true)
        }

        @Test
        func `Flags static constants`() {
            #expect(RFC_791.Flags.none.rawValue == 0)
            #expect(RFC_791.Flags.none.dontFragment == false)
            #expect(RFC_791.Flags.none.moreFragments == false)

            #expect(RFC_791.Flags.dontFragment.dontFragment == true)
            #expect(RFC_791.Flags.dontFragment.moreFragments == false)

            #expect(RFC_791.Flags.moreFragments.dontFragment == false)
            #expect(RFC_791.Flags.moreFragments.moreFragments == true)
        }

        @Test
        func `Flags from bytes - valid`() throws {

            let flags = try RFC_791.Flags(bytes: [Byte(bitPattern: 0b0100_0000)])
            #expect(flags.dontFragment == true)
            #expect(flags.moreFragments == false)
        }

        @Test
        func `Flags from bytes - MF set`() throws {

            let flags = try RFC_791.Flags(bytes: [Byte(bitPattern: 0b0010_0000)])
            #expect(flags.dontFragment == false)
            #expect(flags.moreFragments == true)
        }

        @Test
        func `Flags from bytes - both set`() throws {

            let flags = try RFC_791.Flags(bytes: [Byte(bitPattern: 0b0110_0000)])
            #expect(flags.dontFragment == true)
            #expect(flags.moreFragments == true)
        }

        @Test
        func `Flags from bytes - empty`() {
            #expect(throws: RFC_791.Flags.Error.self) {
                _ = try RFC_791.Flags(bytes: [] as [Byte])
            }
        }

        @Test
        func `Flags from bytes - reserved bit set`() {

            #expect(throws: RFC_791.Flags.Error.self) {
                _ = try RFC_791.Flags(bytes: [Byte(bitPattern: 0b1000_0000)])
            }
        }

        @Test
        func `Flags serialization`() {
            let flags = RFC_791.Flags(dontFragment: true, moreFragments: false)
            var buffer: [Byte] = []
            flags.serialize(into: &buffer)

            #expect(buffer == [Byte(bitPattern: 0b0100_0000)])
        }

        @Test
        func `Flags bytes property`() {
            let flags = RFC_791.Flags.moreFragments

            #expect(flags.bytes == [Byte(bitPattern: 0b0010_0000)])
        }

        @Test
        func `Flags round trip`() throws {
            let original = RFC_791.Flags(dontFragment: true, moreFragments: true)
            let bytes = original.bytes
            let parsed = try RFC_791.Flags(bytes: bytes)

            #expect(parsed.dontFragment == original.dontFragment)
            #expect(parsed.moreFragments == original.moreFragments)
        }

        @Test
        func `Flags equality`() {
            let flags1 = RFC_791.Flags(dontFragment: true, moreFragments: false)
            let flags2 = RFC_791.Flags(dontFragment: true, moreFragments: false)
            let flags3 = RFC_791.Flags(dontFragment: false, moreFragments: true)

            #expect(flags1 == flags2)
            #expect(flags1 != flags3)
        }

        @Test
        func `Flags hashable`() {
            var set: Set<RFC_791.Flags> = []
            set.insert(.none)
            set.insert(.dontFragment)
            set.insert(.none)

            #expect(set.count == 2)
        }

        @Test
        func `Flags description`() {
            #expect(RFC_791.Flags.none.description == "Flags(none)")
            #expect(RFC_791.Flags.dontFragment.description == "Flags(DF)")
            #expect(RFC_791.Flags.moreFragments.description == "Flags(MF)")

            let both = RFC_791.Flags(dontFragment: true, moreFragments: true)
            #expect(both.description.contains("DF"))
            #expect(both.description.contains("MF"))
        }
    }
}
