#if Coder
    public import Binary
    public import Byte

    extension RFC_791.TotalLength: Binary.Serializable {

        public static func serialize<Buffer: RangeReplaceableCollection>(
            _ value: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(Byte(bitPattern: UInt8(value.rawValue >> 8)))
            buffer.append(Byte(bitPattern: UInt8(value.rawValue & 0xFF)))
        }
    }
#endif
