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

import Testing
import RFC_791
import RFC_791_Standard_Library_Integration

@Suite("RFC 791 Flags UInt8 forwarder")
struct RFC_791_Flags_UInt8_Tests {
    @Test
    func `forwarder produces same bytes as byte-domain primary`() {
        let flags = RFC_791.Flags(dontFragment: true)
        let uint8Bytes: [UInt8] = [UInt8](flags)
        #expect(uint8Bytes == [0b0100_0000])
    }

    @Test
    func `forwarder handles all-flags-set`() {
        let flags = RFC_791.Flags(dontFragment: true, moreFragments: true)
        let uint8Bytes: [UInt8] = [UInt8](flags)
        #expect(uint8Bytes == [0b0110_0000])
    }

    @Test
    func `forwarder handles no-flags`() {
        let flags = RFC_791.Flags.none
        let uint8Bytes: [UInt8] = [UInt8](flags)
        #expect(uint8Bytes == [0])
    }
}
