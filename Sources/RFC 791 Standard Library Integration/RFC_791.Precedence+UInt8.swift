internal import Byte
public import RFC_791

extension [UInt8] {

    @_disfavoredOverload
    public init(_ precedence: RFC_791.Precedence) {
        let typed: [Byte] = [Byte](precedence)
        self = typed.map(\.bitPattern)
    }
}
