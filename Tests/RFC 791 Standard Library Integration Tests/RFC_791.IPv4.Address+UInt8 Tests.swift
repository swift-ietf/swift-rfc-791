import Byte
import RFC_791
import RFC_791_Standard_Library_Integration
import Testing

@Suite
struct `RFC 791 Standard Library Integration Tests` {

    @Test
    func `builds an address from four UInt8 octets`() {
        let address = RFC_791.IPv4.Address(192, 168, 1, 1)
        #expect(address.rawValue == 0xC0A8_0101)
        #expect(address.octets.0 == Byte(bitPattern: 192))
        #expect(address.octets.3 == Byte(bitPattern: 1))
    }

    @Test
    func `agrees with the Byte initializer`() {
        let typed = RFC_791.IPv4.Address(
            Byte(bitPattern: 10), Byte(bitPattern: 0), Byte(bitPattern: 0), Byte(bitPattern: 1)
        )
        #expect(RFC_791.IPv4.Address(10, 0, 0, 1) == typed)
    }
}
