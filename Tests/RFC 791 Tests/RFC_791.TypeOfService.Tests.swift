import Testing

@testable import RFC_791

extension RFC_791.TypeOfService {
    @Suite("RFC 791: Type of Service Tests")
    struct Test {

        @Test
        func `TypeOfService from raw value - valid`() {

            let tos = RFC_791.TypeOfService(rawValue: 0b1110_0100)
            #expect(tos != nil)
            #expect(tos?.rawValue == 0b1110_0100)
        }

        @Test
        func `TypeOfService from raw value - invalid (reserved bits set)`() {

            #expect(RFC_791.TypeOfService(rawValue: 0b0000_0001) == nil)

            #expect(RFC_791.TypeOfService(rawValue: 0b0000_0010) == nil)

            #expect(RFC_791.TypeOfService(rawValue: 0b0000_0011) == nil)
        }

        @Test
        func `TypeOfService from components`() {
            let tos = RFC_791.TypeOfService(
                precedence: .immediate,
                lowDelay: true,
                highThroughput: false,
                highReliability: true
            )

            #expect(tos.precedence == .immediate)
            #expect(tos.lowDelay == true)
            #expect(tos.highThroughput == false)
            #expect(tos.highReliability == true)
        }

        @Test
        func `TypeOfService default values`() {
            let tos = RFC_791.TypeOfService()

            #expect(tos.precedence == .routine)
            #expect(tos.lowDelay == false)
            #expect(tos.highThroughput == false)
            #expect(tos.highReliability == false)
        }

        @Test
        func `TypeOfService precedence extraction`() {

            let tos = RFC_791.TypeOfService(rawValue: 0b1110_0000)!
            #expect(tos.precedence == .networkControl)

            let tos2 = RFC_791.TypeOfService(rawValue: 0b0100_0000)!
            #expect(tos2.precedence == .immediate)
        }

        @Test
        func `TypeOfService flag extraction`() {

            let lowDelay = RFC_791.TypeOfService(rawValue: 0b0001_0000)!
            #expect(lowDelay.lowDelay == true)
            #expect(lowDelay.highThroughput == false)
            #expect(lowDelay.highReliability == false)

            let highThroughput = RFC_791.TypeOfService(rawValue: 0b0000_1000)!
            #expect(highThroughput.lowDelay == false)
            #expect(highThroughput.highThroughput == true)
            #expect(highThroughput.highReliability == false)

            let highReliability = RFC_791.TypeOfService(rawValue: 0b0000_0100)!
            #expect(highReliability.lowDelay == false)
            #expect(highReliability.highThroughput == false)
            #expect(highReliability.highReliability == true)

            let allFlags = RFC_791.TypeOfService(rawValue: 0b0001_1100)!
            #expect(allFlags.lowDelay == true)
            #expect(allFlags.highThroughput == true)
            #expect(allFlags.highReliability == true)
        }

        @Test
        func `TypeOfService static constants`() {
            #expect(RFC_791.TypeOfService.default.rawValue == 0)
            #expect(RFC_791.TypeOfService.minimizeDelay.lowDelay == true)
            #expect(RFC_791.TypeOfService.maximizeThroughput.highThroughput == true)
            #expect(RFC_791.TypeOfService.maximizeReliability.highReliability == true)
        }

        @Test
        func `TypeOfService from bytes - valid`() throws {
            let tos = try RFC_791.TypeOfService(bytes: [0b0101_1100])
            #expect(tos.precedence == .immediate)
            #expect(tos.lowDelay == true)
            #expect(tos.highThroughput == true)
            #expect(tos.highReliability == true)
        }

        @Test
        func `TypeOfService from bytes - empty`() {
            #expect(throws: RFC_791.TypeOfService.Error.self) {
                _ = try RFC_791.TypeOfService(bytes: [] as [Byte])
            }
        }

        @Test
        func `TypeOfService from bytes - reserved bits set`() {
            #expect(throws: RFC_791.TypeOfService.Error.self) {
                _ = try RFC_791.TypeOfService(bytes: [0b0000_0001])
            }
        }

        @Test
        func `TypeOfService serialization`() {
            let tos = RFC_791.TypeOfService(
                precedence: .flash,
                lowDelay: true,
                highThroughput: false,
                highReliability: false
            )
            var buffer: [Byte] = []
            tos.serialize(into: &buffer)

            #expect(buffer == [0x70])
        }

        @Test
        func `TypeOfService bytes property`() {
            let tos = RFC_791.TypeOfService.minimizeDelay
            #expect(tos.bytes == [0b0001_0000])
        }

        @Test
        func `TypeOfService round trip`() throws {
            let original = RFC_791.TypeOfService(
                precedence: .criticEcp,
                lowDelay: true,
                highThroughput: true,
                highReliability: false
            )

            let bytes = original.bytes
            let parsed = try RFC_791.TypeOfService(bytes: bytes)

            #expect(parsed == original)
            #expect(parsed.precedence == .criticEcp)
            #expect(parsed.lowDelay == true)
            #expect(parsed.highThroughput == true)
            #expect(parsed.highReliability == false)
        }

        @Test
        func `TypeOfService equality`() {
            let tos1 = RFC_791.TypeOfService(precedence: .flash, lowDelay: true)
            let tos2 = RFC_791.TypeOfService(precedence: .flash, lowDelay: true)
            let tos3 = RFC_791.TypeOfService(precedence: .flash, lowDelay: false)

            #expect(tos1 == tos2)
            #expect(tos1 != tos3)
        }

        @Test
        func `TypeOfService hashable`() {
            var set: Set<RFC_791.TypeOfService> = []
            set.insert(.default)
            set.insert(.minimizeDelay)
            set.insert(.default)

            #expect(set.count == 2)
        }

        @Test
        func `TypeOfService description`() {
            let tos = RFC_791.TypeOfService(
                precedence: .immediate,
                lowDelay: true,
                highThroughput: false,
                highReliability: true
            )
            let desc = tos.description
            #expect(desc.contains("Immediate"))
            #expect(desc.contains("LowDelay"))
            #expect(desc.contains("HighReliability"))
            #expect(!desc.contains("HighThroughput"))
        }
    }
}
