import Testing

@testable import RFC_791

extension RFC_791.Precedence {
    @Suite("RFC 791: Precedence Tests")
    struct Test {

        @Test
        func `Precedence from raw value - valid`() {
            for value: UInt8 in 0...7 {
                let typed = Byte(value)
                let precedence = RFC_791.Precedence(rawValue: typed)
                #expect(precedence != nil)
                #expect(precedence?.rawValue == typed)
            }
        }

        @Test
        func `Precedence from raw value - invalid`() {
            #expect(RFC_791.Precedence(rawValue: 8) == nil)
            #expect(RFC_791.Precedence(rawValue: 255) == nil)
        }

        @Test
        func `Precedence static constants`() {
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
        func `Precedence from bytes - valid`() throws {
            let precedence = try RFC_791.Precedence(bytes: [0x03])
            #expect(precedence == .flash)
        }

        @Test
        func `Precedence from bytes - empty`() {
            #expect(throws: RFC_791.Precedence.Error.self) {
                _ = try RFC_791.Precedence(bytes: [] as [Byte])
            }
        }

        @Test
        func `Precedence from bytes - out of range`() {
            #expect(throws: RFC_791.Precedence.Error.self) {
                _ = try RFC_791.Precedence(bytes: [0x08])
            }
        }

        @Test
        func `Precedence serialization`() {
            let precedence = RFC_791.Precedence.immediate
            var buffer: [Byte] = []
            precedence.serialize(into: &buffer)
            #expect(buffer == [0x02])
        }

        @Test
        func `Precedence bytes property`() {
            let precedence = RFC_791.Precedence.flash
            #expect(precedence.bytes == [0x03])
        }

        @Test
        func `Precedence comparable`() {
            #expect(RFC_791.Precedence.routine < .priority)
            #expect(RFC_791.Precedence.priority < .immediate)
            #expect(RFC_791.Precedence.immediate < .flash)
            #expect(RFC_791.Precedence.flash < .flashOverride)
            #expect(RFC_791.Precedence.flashOverride < .criticEcp)
            #expect(RFC_791.Precedence.criticEcp < .internetworkControl)
            #expect(RFC_791.Precedence.internetworkControl < .networkControl)
        }

        @Test
        func `Precedence description`() {
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
        func `Precedence equality`() {
            let prec1 = RFC_791.Precedence.flash
            let prec2 = RFC_791.Precedence(rawValue: 3)!
            let prec3 = RFC_791.Precedence.immediate

            #expect(prec1 == prec2)
            #expect(prec1 != prec3)
        }

        @Test
        func `Precedence hashable`() {
            var set: Set<RFC_791.Precedence> = []
            set.insert(.routine)
            set.insert(.priority)
            set.insert(.routine)

            #expect(set.count == 2)
            #expect(set.contains(.routine))
            #expect(set.contains(.priority))
        }
    }
}
