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

extension RFC_791.TypeOfService {
    @Suite("RFC 791 TypeOfService UInt8 forwarder")
    struct Test {
        @Test
        func `forwarder produces same byte as byte-domain primary`() {
            let tos = RFC_791.TypeOfService(precedence: .immediate, lowDelay: true)
            let uint8Bytes: [UInt8] = [UInt8](tos)
            // precedence(2) << 5 | lowDelay(bit 3) = 0b0100_0000 | 0b0001_0000 = 0x50
            #expect(uint8Bytes == [0x50])
        }

        @Test
        func `forwarder handles default TOS`() {
            let tos = RFC_791.TypeOfService.default
            let uint8Bytes: [UInt8] = [UInt8](tos)
            #expect(uint8Bytes == [0])
        }

        @Test
        func `forwarder handles all flags set`() {
            let tos = RFC_791.TypeOfService(
                precedence: .networkControl,
                lowDelay: true,
                highThroughput: true,
                highReliability: true
            )
            let uint8Bytes: [UInt8] = [UInt8](tos)
            // 0b111 << 5 | 0b0001_0000 | 0b0000_1000 | 0b0000_0100 = 0xE0 | 0x1C = 0xFC
            #expect(uint8Bytes == [0xFC])
        }
    }
}
