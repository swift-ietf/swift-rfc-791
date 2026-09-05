import RFC_791
import Testing

extension `RFC 791 Tests`.`Identification Tests` {

    @Test
    func `accepts every 16-bit value`() {
        #expect(RFC_791.Identification(rawValue: 0).rawValue == 0)
        #expect(RFC_791.Identification(rawValue: 0x1234).rawValue == 0x1234)
        #expect(RFC_791.Identification(rawValue: 0xFFFF).rawValue == 65535)
    }

    @Test
    func `is expressible by an integer literal`() {
        let id: RFC_791.Identification = 0x5678
        #expect(id.rawValue == 0x5678)
    }

    @Test
    func `describes itself in hexadecimal`() {
        #expect(RFC_791.Identification(rawValue: 0x1234).description == "0x1234")
        #expect(RFC_791.Identification(rawValue: 0x0001).description == "0x1")
        #expect(RFC_791.Identification(rawValue: 0xFFFF).description == "0xFFFF")
    }

    @Test
    func `orders identifications numerically`() {
        #expect(RFC_791.Identification(rawValue: 100) < RFC_791.Identification(rawValue: 200))
    }
}
