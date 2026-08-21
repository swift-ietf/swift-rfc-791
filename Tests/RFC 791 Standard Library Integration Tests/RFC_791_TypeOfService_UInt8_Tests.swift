import RFC_791
import RFC_791_Standard_Library_Integration
import Testing

extension RFC_791.TypeOfService {
    @Suite("RFC 791 TypeOfService UInt8 forwarder")
    struct Test {
        @Test
        func `forwarder produces same byte as byte-domain primary`() {
            let tos = RFC_791.TypeOfService(precedence: .immediate, lowDelay: true)
            let uint8Bytes: [UInt8] = [UInt8](tos)

            #expect(uint8Bytes == [0x50])
        }

        @Test
        func `forwarder handles default TOS`() {
            let tos = RFC_791.TypeOfService.default
            let uint8Bytes: [UInt8] = [UInt8](tos)
            #expect(uint8Bytes == [0])
        }

        @Test
        func `forwarder handles all flags set`() {
            let tos = RFC_791.TypeOfService(
                precedence: .networkControl,
                lowDelay: true,
                highThroughput: true,
                highReliability: true
            )
            let uint8Bytes: [UInt8] = [UInt8](tos)

            #expect(uint8Bytes == [0xFC])
        }
    }
}
