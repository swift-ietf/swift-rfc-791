internal import Byte_Primitives
public import RFC_791

extension [UInt8] {

    @_disfavoredOverload
    public init(_ flags: RFC_791.Flags) {
        let typed: [Byte] = [Byte](flags)
        self = typed.underlying
    }
}
