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

// RFC_791.Identification+UInt8.swift
//
// Stdlib-interop UInt8 forwarder for Identification field. Primary
// byte-domain API lives in `RFC 791`; this forwarder bridges stdlib
// callers carrying `[UInt8]` via `.underlying` on the byte-domain result.
// Per [API-BYTE-007] (byte-discipline skill).

public import RFC_791
internal import Byte_Primitives

extension [UInt8] {
    /// Stdlib-interop forwarder: byte representation as `[UInt8]`.
    @_disfavoredOverload
    public init(_ identification: RFC_791.Identification) {
        let typed: [Byte] = [Byte](identification)
        self = typed.underlying
    }
}
