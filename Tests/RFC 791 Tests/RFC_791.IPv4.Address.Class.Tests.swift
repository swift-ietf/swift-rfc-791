import Testing

@testable import RFC_791

extension RFC_791.IPv4.Address.Class {
    @Suite("RFC 791: IPv4 Address Class Tests")
    struct Test {

        @Test
        func `Class A detection - first octet 0-127`() {

            let addr0 = RFC_791.IPv4.Address(0, 0, 0, 1)
            #expect(addr0.class == .a)

            let addr10 = RFC_791.IPv4.Address(10, 0, 0, 1)
            #expect(addr10.class == .a)

            let addr127 = RFC_791.IPv4.Address(127, 255, 255, 255)
            #expect(addr127.class == .a)
        }

        @Test
        func `Class B detection - first octet 128-191`() {

            let addr128 = RFC_791.IPv4.Address(128, 0, 0, 1)
            #expect(addr128.class == .b)

            let addr172 = RFC_791.IPv4.Address(172, 16, 0, 1)
            #expect(addr172.class == .b)

            let addr191 = RFC_791.IPv4.Address(191, 255, 255, 255)
            #expect(addr191.class == .b)
        }

        @Test
        func `Class C detection - first octet 192-223`() {

            let addr192 = RFC_791.IPv4.Address(192, 0, 0, 1)
            #expect(addr192.class == .c)

            let addr192x168 = RFC_791.IPv4.Address(192, 168, 1, 1)
            #expect(addr192x168.class == .c)

            let addr223 = RFC_791.IPv4.Address(223, 255, 255, 255)
            #expect(addr223.class == .c)
        }

        @Test
        func `Class D detection - first octet 224-239 (multicast)`() {

            let addr224 = RFC_791.IPv4.Address(224, 0, 0, 1)
            #expect(addr224.class == .d)
            #expect(addr224.is.multicast)

            let addr239 = RFC_791.IPv4.Address(239, 255, 255, 255)
            #expect(addr239.class == .d)
            #expect(addr239.is.multicast)
        }

        @Test
        func `Class E detection - first octet 240-255 (reserved)`() {

            let addr240 = RFC_791.IPv4.Address(240, 0, 0, 1)
            #expect(addr240.class == .e)
            #expect(addr240.is.reserved)

            let addr255 = RFC_791.IPv4.Address(255, 255, 255, 255)
            #expect(addr255.class == .e)
            #expect(addr255.is.reserved)
        }

        @Test
        func `Class boundaries`() {

            #expect(RFC_791.IPv4.Address(127, 0, 0, 0).class == .a)
            #expect(RFC_791.IPv4.Address(128, 0, 0, 0).class == .b)

            #expect(RFC_791.IPv4.Address(191, 0, 0, 0).class == .b)
            #expect(RFC_791.IPv4.Address(192, 0, 0, 0).class == .c)

            #expect(RFC_791.IPv4.Address(223, 0, 0, 0).class == .c)
            #expect(RFC_791.IPv4.Address(224, 0, 0, 0).class == .d)

            #expect(RFC_791.IPv4.Address(239, 0, 0, 0).class == .d)
            #expect(RFC_791.IPv4.Address(240, 0, 0, 0).class == .e)
        }

        @Test
        func `is.multicast property`() {
            #expect(!RFC_791.IPv4.Address(192, 168, 1, 1).is.multicast)
            #expect(RFC_791.IPv4.Address(224, 0, 0, 1).is.multicast)
            #expect(!RFC_791.IPv4.Address(255, 255, 255, 255).is.multicast)
        }

        @Test
        func `is.reserved property`() {
            #expect(!RFC_791.IPv4.Address(192, 168, 1, 1).is.reserved)
            #expect(!RFC_791.IPv4.Address(224, 0, 0, 1).is.reserved)
            #expect(RFC_791.IPv4.Address(240, 0, 0, 1).is.reserved)
            #expect(RFC_791.IPv4.Address(255, 255, 255, 255).is.reserved)
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
