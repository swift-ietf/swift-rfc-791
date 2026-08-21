internal import Byte_Primitives
public import RFC_791

extension [UInt8] {

    @_disfavoredOverload
    public init(_ proto: RFC_791.`Protocol`) {
        let typed: [Byte] = [Byte](proto)
        self = typed.underlying
    }
}
