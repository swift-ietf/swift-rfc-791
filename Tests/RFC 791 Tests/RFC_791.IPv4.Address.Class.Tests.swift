import Testing

@testable import RFC_791

private func address(
    _ octet1: UInt8,
    _ octet2: UInt8,
    _ octet3: UInt8,
    _ octet4: UInt8
) -> RFC_791.IPv4.Address {
    RFC_791.IPv4.Address(
        Byte(bitPattern: octet1),
        Byte(bitPattern: octet2),
        Byte(bitPattern: octet3),
        Byte(bitPattern: octet4)
    )
}

extension RFC_791.IPv4.Address.Class {
    @Suite("RFC 791: IPv4 Address Class Tests")
    struct Test {

        @Test
        func `Class A detection - first octet 0-127`() {

            let addr0 = address(0, 0, 0, 1)
            #expect(addr0.class == .a)

            let addr10 = address(10, 0, 0, 1)
            #expect(addr10.class == .a)

            let addr127 = address(127, 255, 255, 255)
            #expect(addr127.class == .a)
        }

        @Test
        func `Class B detection - first octet 128-191`() {

            let addr128 = address(128, 0, 0, 1)
            #expect(addr128.class == .b)

            let addr172 = address(172, 16, 0, 1)
            #expect(addr172.class == .b)

            let addr191 = address(191, 255, 255, 255)
            #expect(addr191.class == .b)
        }

        @Test
        func `Class C detection - first octet 192-223`() {

            let addr192 = address(192, 0, 0, 1)
            #expect(addr192.class == .c)

            let addr192x168 = address(192, 168, 1, 1)
            #expect(addr192x168.class == .c)

            let addr223 = address(223, 255, 255, 255)
            #expect(addr223.class == .c)
        }

        @Test
        func `Class D detection - first octet 224-239 (multicast)`() {

            let addr224 = address(224, 0, 0, 1)
            #expect(addr224.class == .d)
            #expect(addr224.is.multicast)

            let addr239 = address(239, 255, 255, 255)
            #expect(addr239.class == .d)
            #expect(addr239.is.multicast)
        }

        @Test
        func `Class E detection - first octet 240-255 (reserved)`() {

            let addr240 = address(240, 0, 0, 1)
            #expect(addr240.class == .e)
            #expect(addr240.is.reserved)

            let addr255 = address(255, 255, 255, 255)
            #expect(addr255.class == .e)
            #expect(addr255.is.reserved)
        }

        @Test
        func `Class boundaries`() {

            #expect(address(127, 0, 0, 0).class == .a)
            #expect(address(128, 0, 0, 0).class == .b)

            #expect(address(191, 0, 0, 0).class == .b)
            #expect(address(192, 0, 0, 0).class == .c)

            #expect(address(223, 0, 0, 0).class == .c)
            #expect(address(224, 0, 0, 0).class == .d)

            #expect(address(239, 0, 0, 0).class == .d)
            #expect(address(240, 0, 0, 0).class == .e)
        }

        @Test
        func `is.multicast property`() {
            #expect(!address(192, 168, 1, 1).is.multicast)
            #expect(address(224, 0, 0, 1).is.multicast)
            #expect(!address(255, 255, 255, 255).is.multicast)
        }

        @Test
        func `is.reserved property`() {
            #expect(!address(192, 168, 1, 1).is.reserved)
            #expect(!address(224, 0, 0, 1).is.reserved)
            #expect(address(240, 0, 0, 1).is.reserved)
            #expect(address(255, 255, 255, 255).is.reserved)
        }

        @Test
        func `Class description`() {
            #expect(RFC_791.IPv4.Address.Class.a.description == "Class A")
            #expect(RFC_791.IPv4.Address.Class.b.description == "Class B")
            #expect(RFC_791.IPv4.Address.Class.c.description == "Class C")
            #expect(RFC_791.IPv4.Address.Class.d.description == "Class D (Multicast)")
            #expect(RFC_791.IPv4.Address.Class.e.description == "Class E (Reserved)")
        }
    }
}
