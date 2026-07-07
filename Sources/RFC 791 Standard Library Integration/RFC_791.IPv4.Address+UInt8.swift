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

// RFC_791.IPv4.Address+UInt8.swift
//
// Stdlib-interop UInt8 forwarder for IPv4 Address. Primary byte-domain
// API lives in `RFC 791`; this forwarder bridges stdlib callers passing
// four `UInt8` octets (e.g. from network buffers) via `Byte.init`.
// Per [API-BYTE-007] (byte-discipline skill).

internal import Byte_Primitives
public import RFC_791

extension RFC_791.IPv4.Address {
    /// Stdlib-interop forwarder: construction from four `UInt8` octets.
    @_disfavoredOverload
    public init(_ octet1: UInt8, _ octet2: UInt8, _ octet3: UInt8, _ octet4: UInt8) {
        self.init(Byte(octet1), Byte(octet2), Byte(octet3), Byte(octet4))
    }
}
