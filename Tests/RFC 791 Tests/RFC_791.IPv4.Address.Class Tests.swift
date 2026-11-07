import RFC_791
import Testing

extension `RFC 791 Tests`.`IPv4 Address Class Tests` {

    @Test
    func `classifies first octets 0 through 127 as class A`() {
        #expect(RFC_791.IPv4.Address.octetTuple(0, 0, 0, 1).class == .a)
        #expect(RFC_791.IPv4.Address.octetTuple(10, 0, 0, 1).class == .a)
        #expect(RFC_791.IPv4.Address.octetTuple(127, 255, 255, 255).class == .a)
    }

    @Test
    func `classifies first octets 128 through 191 as class B`() {
        #expect(RFC_791.IPv4.Address.octetTuple(128, 0, 0, 1).class == .b)
        #expect(RFC_791.IPv4.Address.octetTuple(172, 16, 0, 1).class == .b)
        #expect(RFC_791.IPv4.Address.octetTuple(191, 255, 255, 255).class == .b)
    }

    @Test
    func `classifies first octets 192 through 223 as class C`() {
        #expect(RFC_791.IPv4.Address.octetTuple(192, 0, 0, 1).class == .c)
        #expect(RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1).class == .c)
        #expect(RFC_791.IPv4.Address.octetTuple(223, 255, 255, 255).class == .c)
    }

    @Test
    func `classifies first octets 224 through 239 as class D multicast`() {
        #expect(RFC_791.IPv4.Address.octetTuple(224, 0, 0, 1).class == .d)
        #expect(RFC_791.IPv4.Address.octetTuple(224, 0, 0, 1).is.multicast)
        #expect(RFC_791.IPv4.Address.octetTuple(239, 255, 255, 255).is.multicast)
    }

    @Test
    func `classifies first octets 240 through 255 as class E reserved`() {
        #expect(RFC_791.IPv4.Address.octetTuple(240, 0, 0, 1).class == .e)
        #expect(RFC_791.IPv4.Address.octetTuple(240, 0, 0, 1).is.reserved)
        #expect(RFC_791.IPv4.Address.broadcast.is.reserved)
    }

    @Test
    func `switches class exactly at the boundaries`() {
        #expect(RFC_791.IPv4.Address.octetTuple(127, 0, 0, 0).class == .a)
        #expect(RFC_791.IPv4.Address.octetTuple(128, 0, 0, 0).class == .b)
        #expect(RFC_791.IPv4.Address.octetTuple(191, 0, 0, 0).class == .b)
        #expect(RFC_791.IPv4.Address.octetTuple(192, 0, 0, 0).class == .c)
        #expect(RFC_791.IPv4.Address.octetTuple(223, 0, 0, 0).class == .c)
        #expect(RFC_791.IPv4.Address.octetTuple(224, 0, 0, 0).class == .d)
        #expect(RFC_791.IPv4.Address.octetTuple(239, 0, 0, 0).class == .d)
        #expect(RFC_791.IPv4.Address.octetTuple(240, 0, 0, 0).class == .e)
    }

    @Test
    func `unicast addresses are neither multicast nor reserved`() {
        let address = RFC_791.IPv4.Address.octetTuple(192, 168, 1, 1)
        #expect(!address.is.multicast)
        #expect(!address.is.reserved)
    }

    @Test
    func `describes each class`() {
        #expect(RFC_791.IPv4.Address.Class.a.description == "Class A")
        #expect(RFC_791.IPv4.Address.Class.b.description == "Class B")
        #expect(RFC_791.IPv4.Address.Class.c.description == "Class C")
        #expect(RFC_791.IPv4.Address.Class.d.description == "Class D (Multicast)")
        #expect(RFC_791.IPv4.Address.Class.e.description == "Class E (Reserved)")
    }
}
