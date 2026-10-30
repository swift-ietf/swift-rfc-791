#if Coder
    public import Binary
    public import Byte

    extension RFC_791.FragmentOffset: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ value: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(value.rawValue, endianness: .big)
        }
    }
#endif
