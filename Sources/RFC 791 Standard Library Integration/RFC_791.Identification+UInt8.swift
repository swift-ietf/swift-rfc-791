internal import Byte
public import RFC_791

extension [UInt8] {

    @_disfavoredOverload
    public init(_ identification: RFC_791.Identification) {
        let typed: [Byte] = [Byte](identification)
        self = typed.map(\.bitPattern)
    }
}
