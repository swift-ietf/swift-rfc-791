import RFC_791
import Testing

extension `RFC 791 Tests`.`IHL Tests` {

    @Test
    func `accepts 5 through 15 words`() {
        for value: UInt8 in 5...15 {
            #expect(RFC_791.IHL(rawValue: value)?.rawValue == value)
        }
    }

    @Test
    func `rejects fewer than 5 words`() {
        for value: UInt8 in 0..<5 {
            #expect(RFC_791.IHL(rawValue: value) == nil)
        }
    }

    @Test
    func `rejects more than 15 words`() {
        for value: UInt8 in 16...255 {
            #expect(RFC_791.IHL(rawValue: value) == nil)
        }
    }

    @Test
    func `bounds the header length`() {
        #expect(RFC_791.IHL.minimum.rawValue == 5)
        #expect(RFC_791.IHL.minimum.byteLength == 20)
        #expect(RFC_791.IHL.maximum.rawValue == 15)
        #expect(RFC_791.IHL.maximum.byteLength == 60)
    }

    @Test
    func `measures the header in bytes`() {
        #expect(RFC_791.IHL(rawValue: 6)?.byteLength == 24)
        #expect(RFC_791.IHL(rawValue: 10)?.byteLength == 40)
    }

    @Test
    func `measures the options in bytes`() {
        #expect(RFC_791.IHL(rawValue: 5)?.optionsLength == 0)
        #expect(RFC_791.IHL(rawValue: 6)?.optionsLength == 4)
        #expect(RFC_791.IHL(rawValue: 15)?.optionsLength == 40)
    }

    @Test
    func `reports whether options are present`() {
        #expect(RFC_791.IHL(rawValue: 5)?.hasOptions == false)
        #expect(RFC_791.IHL(rawValue: 6)?.hasOptions == true)
    }

    @Test
    func `derives the word count from a byte length`() {
        #expect(RFC_791.IHL.fromByteLength(20)?.rawValue == 5)
        #expect(RFC_791.IHL.fromByteLength(24)?.rawValue == 6)
        #expect(RFC_791.IHL.fromByteLength(60)?.rawValue == 15)
    }

    @Test
    func `rejects byte lengths that are out of range or unaligned`() {
        #expect(RFC_791.IHL.fromByteLength(16) == nil)
        #expect(RFC_791.IHL.fromByteLength(64) == nil)
        #expect(RFC_791.IHL.fromByteLength(21) == nil)
    }

    @Test
    func `describes itself`() {
        #expect(RFC_791.IHL(rawValue: 5)?.description == "IHL(5 words, 20 bytes)")
        #expect(RFC_791.IHL(rawValue: 15)?.description == "IHL(15 words, 60 bytes)")
    }

    @Test
    func `orders header lengths numerically`() {
        #expect(RFC_791.IHL.minimum < RFC_791.IHL.maximum)
        #expect(RFC_791.IHL(rawValue: 6)! < RFC_791.IHL(rawValue: 10)!)
    }
}
