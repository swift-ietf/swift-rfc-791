internal import Byte
public import RFC_791

extension RFC_791.IPv4.Address {

    @_disfavoredOverload
    public init(_ octet1: UInt8, _ octet2: UInt8, _ octet3: UInt8, _ octet4: UInt8) {
        self.init(
            Byte(bitPattern: octet1),
            Byte(bitPattern: octet2),
            Byte(bitPattern: octet3),
            Byte(bitPattern: octet4)
        )
    }
}
