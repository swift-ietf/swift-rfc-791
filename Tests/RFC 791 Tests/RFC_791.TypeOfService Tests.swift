import RFC_791
import Testing

extension `RFC 791 Tests`.`Type of Service Tests` {

    @Test
    func `accepts a raw value with the reserved bits clear`() {
        #expect(RFC_791.TypeOfService(rawValue: 0b1110_0100)?.rawValue == 0b1110_0100)
    }

    @Test
    func `rejects a raw value with a reserved bit set`() {
        #expect(RFC_791.TypeOfService(rawValue: 0b0000_0001) == nil)
        #expect(RFC_791.TypeOfService(rawValue: 0b0000_0010) == nil)
        #expect(RFC_791.TypeOfService(rawValue: 0b0000_0011) == nil)
    }

    @Test
    func `composes precedence and flags`() {
        let tos = RFC_791.TypeOfService(
            precedence: .immediate,
            lowDelay: true,
            highThroughput: false,
            highReliability: true
        )
        #expect(tos.precedence == .immediate)
        #expect(tos.lowDelay)
        #expect(!tos.highThroughput)
        #expect(tos.highReliability)
        #expect(tos.rawValue == 0b0101_0100)
    }

    @Test
    func `defaults to routine precedence with no flags`() {
        let tos = RFC_791.TypeOfService()
        #expect(tos == .default)
        #expect(tos.precedence == .routine)
        #expect(!tos.lowDelay)
        #expect(!tos.highThroughput)
        #expect(!tos.highReliability)
    }

    @Test
    func `extracts the precedence from the top three bits`() {
        #expect(RFC_791.TypeOfService(rawValue: 0b1110_0000)?.precedence == .networkControl)
        #expect(RFC_791.TypeOfService(rawValue: 0b0100_0000)?.precedence == .immediate)
    }

    @Test
    func `extracts each flag from its bit`() {
        #expect(RFC_791.TypeOfService(rawValue: 0b0001_0000)?.lowDelay == true)
        #expect(RFC_791.TypeOfService(rawValue: 0b0000_1000)?.highThroughput == true)
        #expect(RFC_791.TypeOfService(rawValue: 0b0000_0100)?.highReliability == true)

        let all = RFC_791.TypeOfService(rawValue: 0b0001_1100)!
        #expect(all.lowDelay && all.highThroughput && all.highReliability)
    }

    @Test
    func `names the single-flag services`() {
        #expect(RFC_791.TypeOfService.minimizeDelay.lowDelay)
        #expect(RFC_791.TypeOfService.maximizeThroughput.highThroughput)
        #expect(RFC_791.TypeOfService.maximizeReliability.highReliability)
    }

    @Test
    func `is equatable and hashable by value`() {
        #expect(
            RFC_791.TypeOfService(precedence: .flash, lowDelay: true)
                == RFC_791.TypeOfService(precedence: .flash, lowDelay: true)
        )
        let set: Set<RFC_791.TypeOfService> = [.default, .minimizeDelay, .default]
        #expect(set.count == 2)
    }

    @Test
    func `describes itself`() {
        #expect(
            RFC_791.TypeOfService.default.description
                == "TypeOfService(precedence: Routine, flags: [None])"
        )
        #expect(
            RFC_791.TypeOfService(precedence: .flash, lowDelay: true, highReliability: true).description
                == "TypeOfService(precedence: Flash, flags: [LowDelay, HighReliability])"
        )
    }
}
