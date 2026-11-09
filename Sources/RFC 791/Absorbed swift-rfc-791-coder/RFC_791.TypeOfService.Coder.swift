#if Coder
    import Binary
    public import Byte
    public import Coder
    public import Cursor
    import Parser
    import Serializer

    extension RFC_791.TypeOfService {
        public struct Coder<Input: Cursor.`Protocol`<Byte, Never>, Buffer: RangeReplaceableCollection<Byte>>: Coding {
            public init() {}
        }

        public static var coder: Coder<ArraySlice<Byte>, [Byte]> { .init() }
    }

    extension RFC_791.TypeOfService.Coder {
        public typealias Output = RFC_791.TypeOfService

        public typealias Failure = RFC_791.TypeOfService.Error

        public borrowing func parse(_ input: inout Input) throws(Failure) -> Output {
            let start = input.checkpoint
            guard let byte = input.next() else {
                throw .empty
            }
            guard let tos = RFC_791.TypeOfService(rawValue: byte.bitPattern) else {
                input.seek(to: start)
                throw .reservedBitsSet(byte)
            }
            return tos
        }

        public borrowing func serialize(_ output: Output, into buffer: inout Buffer) throws(Failure) {
            RFC_791.TypeOfService.serialize(output, into: &buffer)
        }
    }
#endif
