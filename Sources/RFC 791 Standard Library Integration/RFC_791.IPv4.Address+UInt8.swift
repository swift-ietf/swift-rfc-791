internal import Byte_Primitives
public import RFC_791

extension RFC_791.IPv4.Address {

    @_disfavoredOverload
    public init(_ octet1: UInt8, _ octet2: UInt8, _ octet3: UInt8, _ octet4: UInt8) {
        self.init(Byte(octet1), Byte(octet2), Byte(octet3), Byte(octet4))
    }
}
