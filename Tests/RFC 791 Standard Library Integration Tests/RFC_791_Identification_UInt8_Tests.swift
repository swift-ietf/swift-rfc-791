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

@Suite("RFC 791 Identification UInt8 forwarder")
struct RFC_791_Identification_UInt8_Tests {
    @Test
    func `forwarder produces big-endian UInt8 bytes`() {
        let id = RFC_791.Identification(rawValue: 0x1234)
        let uint8Bytes: [UInt8] = [UInt8](id)
        #expect(uint8Bytes == [0x12, 0x34])
    }

    @Test
    func `forwarder handles zero`() {
        let id = RFC_791.Identification(rawValue: 0)
        let uint8Bytes: [UInt8] = [UInt8](id)
        #expect(uint8Bytes == [0, 0])
    }

    @Test
    func `forwarder handles max value`() {
        let id = RFC_791.Identification(rawValue: 0xFFFF)
        let uint8Bytes: [UInt8] = [UInt8](id)
        #expect(uint8Bytes == [0xFF, 0xFF])
    }
}
