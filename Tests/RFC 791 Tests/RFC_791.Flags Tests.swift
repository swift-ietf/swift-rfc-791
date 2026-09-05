import RFC_791
import Testing

extension `RFC 791 Tests`.`Flags Tests` {

    @Test
    func `accepts a raw value with the reserved bit clear`() {
        let flags = RFC_791.Flags(rawValue: 0b011)
        #expect(flags?.dontFragment == true)
        #expect(flags?.moreFragments == true)
    }

    @Test
    func `rejects a raw value with the reserved bit set`() {
        #expect(RFC_791.Flags(rawValue: 0b100) == nil)
        #expect(RFC_791.Flags(rawValue: 0b111) == nil)
    }

    @Test
    func `composes the two flags`() {
        let df = RFC_791.Flags(dontFragment: true, moreFragments: false)
        #expect(df.dontFragment && !df.moreFragments)

        let mf = RFC_791.Flags(dontFragment: false, moreFragments: true)
        #expect(!mf.dontFragment && mf.moreFragments)

        let both = RFC_791.Flags(dontFragment: true, moreFragments: true)
        #expect(both.dontFragment && both.moreFragments)
    }

    @Test
    func `defaults to no flags`() {
        let flags = RFC_791.Flags()
        #expect(flags == .none)
        #expect(!flags.dontFragment)
        #expect(!flags.moreFragments)
    }

    @Test
    func `names the single-flag values`() {
        #expect(RFC_791.Flags.none.rawValue == 0)
        #expect(RFC_791.Flags.dontFragment.dontFragment)
        #expect(!RFC_791.Flags.dontFragment.moreFragments)
        #expect(RFC_791.Flags.moreFragments.moreFragments)
        #expect(!RFC_791.Flags.moreFragments.dontFragment)
    }

    @Test
    func `is equatable and hashable by value`() {
        #expect(RFC_791.Flags(dontFragment: true) == RFC_791.Flags(dontFragment: true))
        let set: Set<RFC_791.Flags> = [.none, .dontFragment, .none]
        #expect(set.count == 2)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.Flags.none.description == "Flags(none)")
        #expect(RFC_791.Flags.dontFragment.description == "Flags(DF)")
        #expect(RFC_791.Flags.moreFragments.description == "Flags(MF)")
        #expect(RFC_791.Flags(dontFragment: true, moreFragments: true).description == "Flags(DF, MF)")
    }
}
