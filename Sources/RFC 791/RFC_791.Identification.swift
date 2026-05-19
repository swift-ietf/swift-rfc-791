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

extension RFC_791 {
    /// Identification Field (RFC 791)
    ///
    /// A 16-bit field used to identify fragments of an original datagram.
    /// All fragments of a datagram have the same identification value,
    /// allowing the destination to reassemble them.
    ///
    /// ## Binary Format
    ///
    /// Per RFC 791 Section 3.1, Identification is a 16-bit field.
    ///
    /// ## Usage
    ///
    /// - Set by the sender to uniquely identify the datagram
    /// - Used with source address, destination address, and protocol
    ///   to identify all fragments belonging to the same datagram
    /// - Typically incremented for each datagram sent
    ///
    /// ## Example
    ///
    /// ```swift
    /// let id = RFC_791.Identification(rawValue: 0x1234)
    /// print(id.rawValue)  // 4660
    /// ```
    public struct Identification: RawRepresentable, Hashable, Sendable, Codable {
        /// The 16-bit raw value
        public let rawValue: UInt16

        /// Creates an Identification value WITHOUT validation
        ///
        /// **Warning**: Bypasses validation. Only use for:
        /// - Static constants
        /// - Pre-validated values
        /// - Internal construction after validation
        init(__unchecked: Void, rawValue: UInt16) {
            self.rawValue = rawValue
        }

        /// Creates an Identification from a raw value
        ///
        /// All 16-bit values are valid.
        ///
        /// - Parameter rawValue: The identification value (0-65535)
        public init(rawValue: UInt16) {
            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

// MARK: - Byte Parsing

extension RFC_791.Identification {
    /// Creates an Identification from bytes (big-endian)
    ///
    /// - Parameter bytes: Binary data containing the identification (2 bytes, big-endian)
    /// - Throws: `Error` if there are insufficient bytes
    public init<Bytes: Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        var iterator = bytes.makeIterator()

        guard let high = iterator.next() else {
            throw .empty
        }
        guard let low = iterator.next() else {
            throw .insufficientBytes
        }

        // UInt16 storage is arithmetic-domain; cross the byte-domain boundary
        // via .underlying at the conformance boundary.
        let value = UInt16(high.underlying) << 8 | UInt16(low.underlying)
        self.init(__unchecked: (), rawValue: value)
    }
}

// MARK: - Binary.Serializable Conformance

extension RFC_791.Identification: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ identification: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        // UInt16 → [Byte] via Byte-primary BinaryInteger.bytes(endianness:).
        buffer.append(contentsOf: identification.rawValue.bytes(endianness: .big))
    }
}

// MARK: - [Byte] Conversion

extension [Byte] {
    /// Creates byte representation of an Identification field (big-endian)
    ///
    /// ## Category Theory
    ///
    /// Natural transformation: RFC_791.Identification → [Byte]
    ///
    /// - Parameter identification: The Identification value to serialize
    public init(_ identification: RFC_791.Identification) {
        self = identification.rawValue.bytes(endianness: .big)
    }
}

// MARK: - Stdlib-Interop [UInt8] Forwarder

extension [UInt8] {
    /// Stdlib-interop forwarder: byte representation as `[UInt8]`.
    @_disfavoredOverload
    public init(_ identification: RFC_791.Identification) {
        let typed: [Byte] = identification.rawValue.bytes(endianness: .big)
        self = typed.underlying
    }
}

// MARK: - CustomStringConvertible

extension RFC_791.Identification: CustomStringConvertible {
    public var description: String {
        "0x\(String(rawValue, radix: 16, uppercase: true))"
    }
}

// MARK: - Comparable

extension RFC_791.Identification: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension RFC_791.Identification: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt16) {
        self.init(__unchecked: (), rawValue: value)
    }
}
