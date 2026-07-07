// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// `Binary_Parseable_Primitives` re-exports a `Collection` / buffer-protocol
// family that shadows the stdlib protocols within this file's scope. Every
// collection-protocol reference below is therefore `Swift.`-qualified so the
// shadow is harmless — qualify the name, don't isolate the conformance into a
// separate file (principal directive; the file-scoped import shadows only here).
public import Binary_Parseable_Primitives
public import Parseable_ASCII_Primitives

extension RFC_791.IPv4 {
    /// IPv4 Address (RFC 791)
    ///
    /// A 32-bit address used to identify hosts on an IP network.
    /// Addresses are commonly represented in dotted-decimal notation (e.g., "192.168.1.1").
    ///
    /// ## Storage
    ///
    /// Internally stored as a single `UInt32` in host byte order (the
    /// integer's most significant byte corresponds to the first octet of the
    /// dotted-decimal representation). Network-order bytes are produced by
    /// `Binary.Serializable.serialize(_:into:)` and `[UInt8](address)` at
    /// serialization boundaries, not at the storage layer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Parse from ASCII bytes (canonical)
    /// let address = try RFC_791.IPv4.Address(ascii: Array<Byte>("192.168.1.1".utf8))
    ///
    /// // Parse from string (convenience)
    /// let address = try RFC_791.IPv4.Address("192.168.1.1")
    ///
    /// // Create from octets
    /// let address = RFC_791.IPv4.Address(192, 168, 1, 1)
    ///
    /// // Serialize to bytes
    /// let bytes = [UInt8](address)
    /// ```
    public struct Address: Hashable, Sendable, Codable {
        /// The 32-bit address value in host byte order.
        ///
        /// The most significant byte corresponds to the first octet of the
        /// dotted-decimal representation. For example, `192.168.1.1` has
        /// `rawValue == 0xC0A80101`, regardless of the host machine's
        /// endianness.
        public let rawValue: UInt32

        /// Creates an IPv4 address WITHOUT validation
        ///
        /// **Warning**: Bypasses RFC validation. Only use for:
        /// - Static constants
        /// - Pre-validated values
        /// - Internal construction after validation
        init(__unchecked: Void, rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Creates an IPv4 address from a 32-bit value.
        ///
        /// - Parameter rawValue: The 32-bit address in host byte order
        ///   (most significant byte is the first dotted-decimal octet).
        public init(rawValue: UInt32) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

// MARK: - Initialization from Octets

extension RFC_791.IPv4.Address {
    /// Creates an IPv4 address from four octets
    ///
    /// Constructs the address from four byte-domain values in standard dotted-decimal order.
    ///
    /// - Parameters:
    ///   - octet1: First octet (most significant byte)
    ///   - octet2: Second octet
    ///   - octet3: Third octet
    ///   - octet4: Fourth octet (least significant byte)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let address = RFC_791.IPv4.Address(192, 168, 1, 1)
    /// ```
    public init(_ octet1: Byte, _ octet2: Byte, _ octet3: Byte, _ octet4: Byte) {
        // UInt32 storage is arithmetic-domain; cross the byte-domain boundary
        // via .underlying.
        let value =
            UInt32(octet1.underlying) << 24
            | UInt32(octet2.underlying) << 16
            | UInt32(octet3.underlying) << 8
            | UInt32(octet4.underlying)
        self.init(__unchecked: (), rawValue: value)
    }

    // Stdlib-interop UInt8 forwarder lives in `RFC 791 Standard Library
    // Integration` per [API-BYTE-007].
}

// MARK: - Octet Access

extension RFC_791.IPv4.Address {
    /// The four octets of the address in standard order
    ///
    /// Returns the address as a tuple of four byte-domain values in the order
    /// they appear in dotted-decimal notation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let address = RFC_791.IPv4.Address(192, 168, 1, 1)
    /// let (a, b, c, d) = address.octets
    /// // a = 192, b = 168, c = 1, d = 1
    /// ```
    public var octets: (Byte, Byte, Byte, Byte) {
        (
            Byte(UInt8((rawValue >> 24) & 0xFF)),
            Byte(UInt8((rawValue >> 16) & 0xFF)),
            Byte(UInt8((rawValue >> 8) & 0xFF)),
            Byte(UInt8(rawValue & 0xFF))
        )
    }
}

// MARK: - Binary.Serializable Conformance
extension RFC_791.IPv4.Address: Binary.Serializable {
    static public func serialize<Buffer>(
        _ address: RFC_791.IPv4.Address,
        into buffer: inout Buffer
    ) where Buffer: Swift.RangeReplaceableCollection, Buffer.Element == Byte {
        let (a, b, c, d) = address.octets
        buffer.append(a)
        buffer.append(b)
        buffer.append(c)
        buffer.append(d)
    }

    /// Creates from binary bytes (4 bytes, network byte order)
    ///
    /// - Parameter bytes: Exactly 4 bytes in network byte order
    /// - Throws: `Error.invalidFormat` if not exactly 4 bytes
    public init<Bytes: Swift.Collection>(binary bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard bytes.count == 4 else {
            throw .invalidFormat("Expected 4 bytes, got \(bytes.count)")
        }

        var iterator = bytes.makeIterator()
        let a = iterator.next()!
        let b = iterator.next()!
        let c = iterator.next()!
        let d = iterator.next()!

        self.init(a, b, c, d)
    }
}

// MARK: - Binary.Parseable Conformance (4-octet wire — network byte order)

extension RFC_791.IPv4.Address: Binary.Parseable {
    /// Parses a 4-octet IPv4 address from the front of `source` (network order).
    ///
    /// [FAM-012] wire sibling carrying the fixed-concrete `Binary.Parse.Failure`
    /// (minimal-B): the binary form's only structural defect is insufficient
    /// input — any four bytes are a valid address. Consumes exactly four bytes
    /// from the front of `source` on success (cursor semantics); leaves `source`
    /// unmodified on failure.
    public static func parse<Source>(
        from source: inout Source
    ) throws(Binary.Parse.Failure) -> RFC_791.IPv4.Address
    where Source: Swift.RangeReplaceableCollection, Source.Element == Byte {
        guard source.count >= 4 else {
            throw .insufficient(needed: 4)
        }

        var iterator = source.makeIterator()
        let a = iterator.next()!
        let b = iterator.next()!
        let c = iterator.next()!
        let d = iterator.next()!
        source.removeFirst(4)

        return RFC_791.IPv4.Address(a, b, c, d)
    }
}

// MARK: - ASCII.Serializable Conformance (dotted-decimal text — RFC 791 §3.2)

extension RFC_791.IPv4.Address: ASCII.Serializable {
    /// Serializes `address` as dotted-decimal ASCII text (e.g. "192.168.1.1").
    ///
    /// [FAM-012] text sibling. **Source-defect-1 fix**: the dotted-decimal form
    /// now emits the typed text substrate `ASCII.Code` directly — it formerly
    /// rode the deprecated `Binary.ASCII.Serializable`, serialising into a
    /// `Byte` buffer (the defect the model §6 corrects). The decimal-digit
    /// arithmetic stays in the `UInt8` arithmetic domain ([API-BYTE-002]); each
    /// digit is lifted to `ASCII.Code` at the append boundary.
    public static func serialize<Buffer>(
        _ address: RFC_791.IPv4.Address,
        into buffer: inout Buffer
    ) where Buffer: Swift.RangeReplaceableCollection, Buffer.Element == ASCII.Code {
        let (a, b, c, d) = address.octets

        buffer.reserveCapacity(15)

        // Helper to append decimal ASCII digits for a UInt8.
        // Arithmetic-domain construction ([API-BYTE-002]): digit math stays in
        // UInt8, lifted to `ASCII.Code` via the `'0'` underlying byte offset.
        func appendDecimal(_ value: UInt8) {
            // Fast path for single digit (0-9)
            if value < 10 {
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ value))
                return
            }

            // Fast path for two digits (10-99)
            if value < 100 {
                let tens = value / 10
                let ones = value % 10
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ tens))
                buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ ones))
                return
            }

            // Three digits (100-255)
            let hundreds = value / 100
            let remainder = value % 100
            let tens = remainder / 10
            let ones = remainder % 10

            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ hundreds))
            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ tens))
            buffer.append(ASCII.Code(ASCII.Code.`0`.underlying &+ ones))
        }

        // Serialize: <a>.<b>.<c>.<d>. octets are Byte; bridge via .underlying
        // at the conformance boundary for arithmetic-domain digit calculation.
        appendDecimal(a.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(b.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(c.underlying)
        buffer.append(ASCII.Code.period)
        appendDecimal(d.underlying)
    }
}

// MARK: - ASCII.Parseable Conformance (dotted-decimal text — RFC 791 §3.2)

extension RFC_791.IPv4.Address: ASCII.Parseable {

    public typealias Failure = RFC_791.IPv4.Address.Error

    /// Creates an IPv4 address from ASCII bytes in dotted-decimal notation
    ///
    /// This is the canonical parsing transformation per STANDARD_IMPLEMENTATION_PATTERNS.md.
    /// String parsing is derived from this as composition:
    /// ```
    /// String → [Byte] (UTF-8) → IPv4.Address
    /// ```
    ///
    /// ## Category Theory
    ///
    /// Parsing transformation:
    /// - **Domain**: [Byte] (ASCII bytes)
    /// - **Codomain**: RFC_791.IPv4.Address (structured data)
    ///
    /// ## Constraints
    ///
    /// Per RFC 791 Section 3.2:
    /// - Four decimal octets separated by periods
    /// - Each octet in range 0-255
    /// - No leading zeros (strict mode)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bytes = Array<Byte>("192.168.1.1".utf8)
    /// let address = try RFC_791.IPv4.Address(ascii: bytes)
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: ASCII bytes representing dotted-decimal notation
    /// - Throws: `Error` if the format is invalid
    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard !bytes.isEmpty else {
            throw .empty
        }

        // Type-up: lift to ASCII.Code at the entry boundary so the body works
        // against ASCII.Code constants directly (RFC 791 dotted-decimal grammar
        // is strict ASCII; non-ASCII bytes are fail-state).
        let arr: [ASCII.Code]
        do {
            // `Swift.Array`-qualified: `Binary_Parseable_Primitives`'s load-bearing
            // re-export brings the institute `Array` (Store&Buffer-constrained) into
            // scope, shadowing the stdlib type at this explicit `Array<…>` spelling.
            // Same qualify-the-name pattern as the collection-protocol references above.
            // swift-format-ignore: UseShorthandTypeNames
            // swiftlint:disable:next syntactic_sugar
            arr = try Swift.Array<ASCII.Code>(bytes)
        } catch {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }

        var octets: [UInt8] = []
        octets.reserveCapacity(4)

        var currentOctet: Int = 0
        var digitCount = 0
        var position = 0

        for code in arr {
            if code == ASCII.Code.period {
                // End of octet
                guard digitCount > 0 else {
                    throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
                }
                guard currentOctet <= 255 else {
                    throw .octetOutOfRange(currentOctet, position: position)
                }
                octets.append(UInt8(currentOctet))
                currentOctet = 0
                digitCount = 0
                position += 1
            } else if code.isDigit {
                // Check for leading zeros (except for "0" itself)
                if digitCount == 1, currentOctet == 0 {
                    throw .leadingZero(String(decoding: bytes, as: UTF8.self), position: position)
                }
                currentOctet = currentOctet * 10 + Int(code.digitValue!)
                digitCount += 1

                // Early overflow check
                if currentOctet > 255 {
                    throw .octetOutOfRange(currentOctet, position: position)
                }
            } else {
                throw .invalidCharacter(
                    String(decoding: bytes, as: UTF8.self),
                    code: code,
                    position: position
                )
            }
        }

        // Handle final octet
        guard digitCount > 0 else {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }
        guard currentOctet <= 255 else {
            throw .octetOutOfRange(currentOctet, position: position)
        }
        octets.append(UInt8(currentOctet))

        // Must have exactly 4 octets
        guard octets.count == 4 else {
            throw .invalidFormat(String(decoding: bytes, as: UTF8.self))
        }

        // Bridge inline at the call site: parse arithmetic-domain `[UInt8]`
        // → byte-domain octets via `Byte.init` (UInt8 forwarder lives in SLI
        // target per [API-BYTE-007]).
        self.init(Byte(octets[0]), Byte(octets[1]), Byte(octets[2]), Byte(octets[3]))
    }
}

// MARK: - CustomStringConvertible

extension RFC_791.IPv4.Address: CustomStringConvertible {
    /// The address in dotted-decimal notation (e.g. "192.168.1.1").
    ///
    /// Derived from the `ASCII.Serializable` verb (`.serialized` projects the
    /// dotted-decimal `ASCII.Code` form to `[Byte]`); re-provided directly now
    /// that the retired `Binary.ASCII.Serializable` no longer supplies it.
    public var description: String {
        String(decoding: serialized, as: UTF8.self)
    }
}

// MARK: - String Conveniences

extension RFC_791.IPv4.Address {
    /// Creates an IPv4 address by parsing the UTF-8 bytes of `string` as
    /// dotted-decimal ASCII. Convenience over the canonical `init(ascii:)`.
    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: [Byte](string.utf8))
    }
}

// MARK: - Comparable

extension RFC_791.IPv4.Address: Comparable {
    /// Compares two IPv4 addresses numerically
    ///
    /// Addresses are compared by their 32-bit numeric value, allowing
    /// for range operations and sorting.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let start = RFC_791.IPv4.Address(192, 168, 1, 1)
    /// let end = RFC_791.IPv4.Address(192, 168, 1, 255)
    /// if address >= start && address <= end {
    ///     print("Address is in range")
    /// }
    /// ```
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension RFC_791.IPv4.Address: ExpressibleByStringLiteral {
    /// Creates an IPv4 address from a dotted-decimal string literal.
    ///
    /// Re-provided directly now that the retired `Binary.ASCII.Serializable`
    /// no longer supplies the `Context == Void` literal default. Traps on an
    /// invalid literal (literals are author-controlled, compile-time constants).
    public init(stringLiteral value: String) {
        do throws(Error) {
            try self.init(value)
        } catch {
            preconditionFailure("Invalid IPv4 address literal '\(value)': \(error)")
        }
    }
}

// MARK: - Static Constants

extension RFC_791.IPv4.Address {
    /// The unspecified address (0.0.0.0)
    public static let `any` = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0)

    /// The broadcast address (255.255.255.255)
    public static let broadcast = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0xFFFF_FFFF)

    /// The loopback address (127.0.0.1)
    public static let loopback = RFC_791.IPv4.Address(__unchecked: (), rawValue: 0x7F00_0001)
}
