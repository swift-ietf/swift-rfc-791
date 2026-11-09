# swift-rfc-791

Use this package when you need IPv4 addresses or the individual fields of an IPv4 header as checked values, or the header checksum. Start from `RFC_791.IPv4.Address` for addresses and `RFC_791.HeaderChecksum` for checksums. Each header field, such as `RFC_791.TTL` or `RFC_791.Flags`, is its own type, and the package has no type for a whole header. If you want IPv4 as one namespace, use swift-ipv4-standard. If you work with both IPv4 and IPv6 addresses, use swift-ip-address. For `Encodable` and `Decodable`, add the `RFC 791 Foundation Integration` product. To build an address from four `UInt8` values, add the `RFC 791 Standard Library Integration` product.

## Laws

- Address text is exactly four decimal octets from 0 to 255 separated by dots. An octet with a leading zero, such as `01`, is refused.
- `RFC_791.IPv4.Address.rawValue` holds the first octet in its high bits. `RFC_791.IPv4.Address.bigEndian` gives the value in network byte order. Addresses order by their raw value.
- `RFC_791.IPv4.Address.class` comes from the leading bits of the first octet alone. Class D is multicast and class E is reserved, so `RFC_791.IPv4.Address.broadcast` counts as reserved.
- `RFC_791.HeaderChecksum.compute(over:)` takes the one's complement of the one's complement sum of the header's big-endian 16-bit words, so the checksum field must be zero when you compute it. `RFC_791.HeaderChecksum.verify(header:)` is true when the header, with its checksum in place, sums to all ones.
- A field's coder reads and writes only that field, at its bit position in the header. The version is the high nibble and the header length the low nibble of the same byte. The flags are the top three bits of their byte, and the precedence the top three bits of the type of service byte. A fragment offset is the low 13 bits of two bytes, so reading ignores the flag bits and writing leaves them zero. Combining fields that share a byte is up to you.
- Multi-byte fields are big-endian. An address's coder reads its four octets as they are on the wire.
- Reading refuses a header length under five words, a flags byte with the reserved bit set, a type of service byte with either of its two low bits set, and a total length under 20 bytes.
- `RFC_791.TTL.decremented` is nil only at zero. Decrementing a TTL of 1 gives an expired TTL.
- A fragment offset counts 8-byte units. `RFC_791.FragmentOffset.fromByteOffset(_:)` returns nil for a byte offset that is negative, not a multiple of 8, or over 65528.
- With `RFC 791 Foundation Integration`, an address encodes as its dotted text and a class as its letter. Every other field encodes as its raw number, and decoding a number the field's range refuses throws a `DecodingError`.
