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

@Suite("RFC 791 Precedence UInt8 forwarder")
struct RFC_791_Precedence_UInt8_Tests {
    @Test
    func `forwarder produces same byte as byte-domain primary`() {
        let precedence = RFC_791.Precedence.flash
        let uint8Bytes: [UInt8] = [UInt8](precedence)
        #expect(uint8Bytes == [3])
    }

    @Test
    func `forwarder handles routine precedence`() {
        let precedence = RFC_791.Precedence.routine
        let uint8Bytes: [UInt8] = [UInt8](precedence)
        #expect(uint8Bytes == [0])
    }

    @Test
    func `forwarder handles network control precedence`() {
        let precedence = RFC_791.Precedence.networkControl
        let uint8Bytes: [UInt8] = [UInt8](precedence)
        #expect(uint8Bytes == [7])
    }
}
