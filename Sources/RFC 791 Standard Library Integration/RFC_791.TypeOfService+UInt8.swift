internal import Byte_Primitives
public import RFC_791

extension [UInt8] {

    @_disfavoredOverload
    public init(_ tos: RFC_791.TypeOfService) {
        let typed: [Byte] = [Byte](tos)
        self = typed.underlying
    }
}
