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

import RFC_791
import RFC_791_Standard_Library_Integration
import Testing

@Suite("RFC 791 IPv4 Address UInt8 forwarder")
struct RFC_791_IPv4_Address_UInt8_Tests {
    @Test
    func `forwarder constructs same value as byte-domain primary`() {
        let octet1: UInt8 = 192
        let octet2: UInt8 = 168
        let octet3: UInt8 = 1
        let octet4: UInt8 = 1
        let address = RFC_791.IPv4.Address(octet1, octet2, octet3, octet4)
        #expect(address.rawValue == 0xC0A8_0101)
    }

    @Test
    func `forwarder handles zero address`() {
        let octet: UInt8 = 0
        let address = RFC_791.IPv4.Address(octet, octet, octet, octet)
        #expect(address.rawValue == 0)
    }

    @Test
    func `forwarder handles broadcast address`() {
        let octet: UInt8 = 255
        let address = RFC_791.IPv4.Address(octet, octet, octet, octet)
        #expect(address.rawValue == 0xFFFF_FFFF)
    }
}
