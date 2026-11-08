import RFC_791
import Testing

extension `RFC 791 Tests`.`Precedence Tests` {

    @Test
    func `accepts 0 through 7`() {
        for value: UInt8 in 0...7 {
            #expect(RFC_791.Precedence(rawValue: value)?.rawValue == value)
        }
    }

    @Test
    func `rejects values above 7`() {
        #expect(RFC_791.Precedence(rawValue: 8) == nil)
        #expect(RFC_791.Precedence(rawValue: 255) == nil)
    }

    @Test
    func `names the eight levels`() {
        #expect(RFC_791.Precedence.routine.rawValue == 0)
        #expect(RFC_791.Precedence.priority.rawValue == 1)
        #expect(RFC_791.Precedence.immediate.rawValue == 2)
        #expect(RFC_791.Precedence.flash.rawValue == 3)
        #expect(RFC_791.Precedence.flashOverride.rawValue == 4)
        #expect(RFC_791.Precedence.criticEcp.rawValue == 5)
        #expect(RFC_791.Precedence.internetworkControl.rawValue == 6)
        #expect(RFC_791.Precedence.networkControl.rawValue == 7)
    }

    @Test
    func `orders the levels from routine to network control`() {
        #expect(RFC_791.Precedence.routine < .priority)
        #expect(RFC_791.Precedence.priority < .immediate)
        #expect(RFC_791.Precedence.immediate < .flash)
        #expect(RFC_791.Precedence.flash < .flashOverride)
        #expect(RFC_791.Precedence.flashOverride < .criticEcp)
        #expect(RFC_791.Precedence.criticEcp < .internetworkControl)
        #expect(RFC_791.Precedence.internetworkControl < .networkControl)
    }

    @Test
    func `describes each level`() {
        #expect(RFC_791.Precedence.routine.description == "Routine")
        #expect(RFC_791.Precedence.priority.description == "Priority")
        #expect(RFC_791.Precedence.immediate.description == "Immediate")
        #expect(RFC_791.Precedence.flash.description == "Flash")
        #expect(RFC_791.Precedence.flashOverride.description == "Flash Override")
        #expect(RFC_791.Precedence.criticEcp.description == "CRITIC/ECP")
        #expect(RFC_791.Precedence.internetworkControl.description == "Internetwork Control")
        #expect(RFC_791.Precedence.networkControl.description == "Network Control")
    }

    @Test
    func `is equatable and hashable by value`() {
        #expect(RFC_791.Precedence.flash == RFC_791.Precedence(rawValue: 3))
        let set: Set<RFC_791.Precedence> = [.routine, .priority, .routine]
        #expect(set.count == 2)
    }
}
